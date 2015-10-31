# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  username      :string(255)      not null
#  email         :string(255)      not null
#  password_hash :string(32)       not null
#  salt          :string(10)       not null
#  last_login    :integer          default(0)
#  last_login_ip :string(15)
#  level         :integer          not null
#  status        :integer          not null
#  created_at    :integer          not null
#  updated_at    :integer
#  is_bot        :integer          default(0)
#

class User < ActiveRecord::Base
  scope :latest, -> { order('created_at DESC') }

  has_many :posts
  has_many :sources
  has_many :favorites
  has_many :authorizations
  has_many :events
  has_one  :profile
  has_many :follows

  LEVELS   = { :admin => 1,
               :editor => 2,
               :subscriber => 3
  }
  STATUSES = { :unconfirmed => 1,
               :confirmed   => 2,
               :banned      => 3,
               :deleted     => 4
  }

  scope :confirmed, -> { where( :status => User::STATUSES[:confirmed] ) }

  validates :email, presence: true,
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
    uniqueness: { case_sensitive: false }

  validates :username, presence: true,
    format: { with: Patterns::ROUTE_PATTERN },
    uniqueness: { case_sensitive: false },
    length: { :minimum => 4, :maximum => 255 }

  validates :password, presence: { :on => :create },
    length: { :minimum => 5, :maximum => 255, :allow_nil => true },
    confirmation: true,
    :unless => "!validations_to_skip.nil? and validations_to_skip.include?('password')"

  validates_inclusion_of :level,  :in => LEVELS.values.freeze
  validates_inclusion_of :status, :in => STATUSES.values.freeze

  validates_associated          :profile
  accepts_nested_attributes_for :profile, update_only: true

  attr_accessor :password, :password_confirmation, :avatar_upload, :validations_to_skip

  before_create :create_salt
  before_create :create_hashed_password
  before_update :update_hashed_password
  before_update :update_avatar

  after_save :invalidate_cache!
  after_create :invalidate_cache!

  def self.authenticate(who, password)
    find_by_sql([ 'SELECT * FROM users WHERE ( username = ? OR email = ? ) AND MD5( CONCAT( salt, ? ) ) = password_hash AND status = ? ', who, who, password, STATUSES[:confirmed] ]).first
  end

  def self.find_by_confirmation_token( token )
    self.where( 'MD5( CONCAT( id, email, username, salt, password_hash ) )  = ?', token ).first
  end

  def self.find_by_api_key( token )
    self.where( 'MD5( CONCAT( id, email, username, salt, password_hash, created_at ) )  = ?', token ).first
  end

  def self.get_random_password( length = 8 )
    (0...length).map{65.+(rand(25)).chr}.join
  end

  def self.activate(token)
    # search user by token
    user = self.find_by_confirmation_token(token)
    unless user.nil?
      # should be unconfirmed yet
      if user.status == STATUSES[:unconfirmed]
        user.status = STATUSES[:confirmed]
        user.save!

        Event.new_registered(user)
      else
        user = nil
      end
    end
    user
  end

  def self.omniauth(auth)
    # at least the email is required to sign in an existing user
    info = auth['info']
    if auth && info && info['email']
      user         = User.find_by_email( info['email'] )
      tmp_password = nil
      profile      = nil

      # new incoming user ^_^
      if user.nil?
        # we need the nickname now
        tmp_nickname = info['nickname'] || info['name']
        if tmp_nickname
          # generate a temporary password
          tmp_password = self.get_random_password
          nickname     = self.get_unique_nickname tmp_nickname

          user = User.create({
            username: nickname,
            email: info['email'],
            password: tmp_password,
            password_confirmation: tmp_password,
            status: STATUSES[:confirmed],
            level: LEVELS[:subscriber]
          })

          profile = Profile.create({ user: user }) unless !user.valid?

          Event.new_registered(user)
        end
        # existing user
      else
        # confirm user if not yet confirmed
        user.status = STATUSES[:confirmed]
        user.save

        profile = user.profile
      end

      update_omniauth_profile( auth, user, profile ) unless profile.nil?

      [ user, tmp_password ]
    end
  end

  def api_key
    Digest::MD5.hexdigest( "#{id}#{email}#{username}#{salt}#{password_hash}#{created_at}" )    
  end

  def favorite_by_others
    Favorite.joins(:source).where('sources.user_id = ?', self.id ).count
  end

  def last_source( not_as = nil )
    if not_as.nil?
      sources.limit(1).first
    else
      sources.where(['id != ?',not_as.id]).limit(1).first
    end
  end

  def is_admin?
    level == LEVELS[:admin]
  end

  def is_banned?
    status == STATUSES[:banned]
  end

  def is_connected?(provider)
    authorizations.where(:provider => provider).any?
  end

  def confirmation_token
    Digest::MD5.hexdigest( "#{id}#{email}#{username}#{salt}#{password_hash}" )
  end

  def rating
    Rating.find_or_create_by( :rateable_type => Rating::RATEABLE_TYPES[:user], :rateable_id => id )
  end

  def favorite?(source)
    Rails.cache.fetch "user_#{id}_favorite?_#{source.id}" do 
      Favorite.where( :user_id => self.id, :source_id => source.id ).any?
    end
  end

  def follows?(object)
    if object.is_a? User
      type = Follow::TYPES[:user]
    elsif object.is_a? Language
      type = Follow::TYPES[:language]
    end

    Rails.cache.fetch "user_#{id}_follows?_#{type}_#{object.id}" do
      Follow.where( :user_id => self.id, :follow_type => type, :follow_id => object.id ).any?      
    end
  end

  def followers
    User.joins(:follows).where(['follows.follow_id = ?', id]).order('follows.created_at DESC')
  end

  def stream( page )
    Rails.cache.fetch "user_#{self.id}_stream_page_#{page}" do
      follows      = self.follows.by_type
      language_ids = []
      user_ids     = []

      follows.each do |follow|
        if follow.follow_type.to_i == Follow::TYPES[:user]
          user_ids << follow.user.id
        elsif follow.follow_type.to_i == Follow::TYPES[:language]
          language_ids << follow.language.id
        end
      end

      Source.includes(:language).visible.where(['user_id IN ( ? ) OR language_id IN ( ? )', user_ids, language_ids]).paginate( :page => page, :per_page => 16 )
    end
  end

  def avatar
    if profile.avatar?
      "/avatars/#{id}.png"
    else
      "icon-user-default.png"
    end
  end

  def language_statistics
    Rails.cache.fetch "user_#{self.id}_stats_#{self.sources.count}" do
      total_hits = 0
      stats      = {}

      # loop by language instead of looping by source
      # since a user could have a huge number of entries,
      # but languages number is known ( and lower ).
      Language.all.each do |language|
        count = language.sources.where( :user_id => id ).count
        stats[language] ||= 0
        stats[language] +=  count
        total_hits += count
      end

      stats.each do |language,hits|
        if hits > 0
          stats[language] = ( ( hits * 100.0 ) / total_hits ).round 1
        else
          stats.delete language
        end
      end

      stats.sort_by(&:last).reverse
    end
  end

  def resize_image(file, resize="50x50", output=Rails.root.join('public', 'avatars', "#{id}.png").to_s)
    image = MiniMagick::Image.open(file)
    image.resize resize
    image.format "png"
    image.write output
    File.chmod(0644, output)
  end

  def set_avatar_file(file)
    resize_image(file)
    profile.avatar = 1
  end

  private

  def self.get_unique_nickname(base)
    counter  = 2
    nickname = base.parameterize
    while User.find_by_username(nickname).nil? == false
      nickname = "#{base}-#{counter}"
      counter += 1
    end

    nickname
  end

  def create_salt
    self.salt = (0...5).map{65.+(rand(25)).chr}.join
  end

  def create_hashed_password
    unless self.password.nil?
      self.password_hash = Digest::MD5.hexdigest( self.salt + self.password )
    end
  end

  def update_hashed_password
    unless self.password.nil?
      self.password_hash = Digest::MD5.hexdigest( self.salt + self.password )
    end
  end

  def update_avatar
    unless self.avatar_upload.nil?
      begin
        set_avatar_file avatar_upload.tempfile.path
      rescue Exception => e
        self.errors.add( :avatar_upload, e.message )
        false
      end
    end
  end

  def self.update_omniauth_profile( auth, user, profile )
    # first of all, check if the user already has an authorization
    # with the given provider
    authorization = Authorization.find_by_provider_and_uid( auth["provider"], auth["uid"] )
    if authorization
      # update data
      authorization.token  = auth['credentials']['token'] unless !auth['credentials'] or !auth['credentials']['token']
      authorization.handle = auth['info']['nickname'] unless !auth['info']['nickname']
      authorization.uid    = auth['uid']
      authorization.save!
    else
      # create the new authorization object
      authorization = Authorization.create({
        :provider => auth['provider'],
        :user_id  => user.id,
        :token    => ( auth['credentials'] && auth['credentials']['token'] ) ? auth['credentials']['token'] : nil,
        :handle   => auth['info']['nickname'] ? auth['info']['nickname'] : nil,
        :uid      => auth['uid']
      })
    end

    begin
      # use default facebook graph avatar if not available from auth info
      if auth['provider'] == 'facebook'
        auth['info']['image'] ||= "http://graph.facebook.com/#{auth['uid']}/picture?type=large"
      end
    rescue; end

    # if user still has no avatar, fetch it from auth info if available
    if profile.avatar == 0 && auth['info']['image']
      begin
        user.set_avatar_file(auth['info']['image'])
      rescue Exception => e
        false
      end

      profile.save!
    end
  end

  protected

  def invalidate_cache!
    expire_fragment( "latest_users_view" )
  end

end
