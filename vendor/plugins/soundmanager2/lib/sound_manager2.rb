# This is a Ruby on Rails wrapper around Scott Schill's SoundManager2 Javascript API 
# (http://www.schillmania.com/projects/soundmanager2/).  
module SoundManager2
  
  # Defines helper methods that are automatically  mixed-in to ActionView::Base by 
  # the Rails plugin, allowing all view files access to them.
  module Helper
    # Generates a "play" button that will toggle to a "pause" button when pressed,
    # and vice versa.  Pressing "play" starts playing the MP3 associated to _sound_id
    # via the SoundManager2 API.  (This method actually generates HTML and Javascript 
    # that should be included in your HTML ERB templates.)
    #
    # The _sound_id_ parameter here must correspond to a value specified by
    # #initialize_sounds (or indirectly via #initialize_sound_manager) or else
    # no sound will play.
    def toggle_sound(sound_id)
      link_to_function image_tag("SoundManager2/play-control.gif", :border => 0), "toggle_sound('#{sound_id}')", :id => "#{sound_id}"
    end
    
    # A convenience method to initialize the SoundManager2 and setup a list of sounds
    # to play later.  The required _sound_array_ variable should be an array of arrays
    # of the following format:  [["sound_1_id", "sound_1_url"], ["sound_2_id", "sound_2_url"]].
    # Passing _debug_ true will create a SoundManager2 console on your page and visibly log all
    # SoundManager2 events.  (There are plenty!)
    def initialize_sounds(sound_array, debug=false)
      initialize_sound_manager(debug) do |soundman|
        sound_array.each do |id, url| 
          soundman.create_sound(id, url)
        end
      end
    end
    
    # Generates HTML that includes the required SoundManager2 Javascsript files,
    # initializes the SoundManager2 API, and optionally allows the developer to 
    # specify initialization actions (like SoundManager#create_sound) via a passed
    # in block.
    def initialize_sound_manager(debug=false, swf_url="/soundmanager2.swf")
      soundman = SoundManager.new
      yield soundman if block_given?

      output = javascript_include_tag("soundmanager2-jsmin") + "\n"
      output += javascript_include_tag("soundmanager2-rails") + "\n"
      output += javascript_tag(%Q{
        soundManager.url = '#{swf_url}';
        soundManager.debugMode = #{debug};
        soundManager.consoleOnly = #{debug};
      })
      
      output += javascript_tag(soundman.onload_function) if soundman.onload_function?
      output
    end
  end
  
  # Internally represents an MP3 URL and identifier passed in to SoundManager.
  # Be careful, as this only represents Javascript that we are *generating*, and
  # not an actual SoundManager2 runtime sound instance.
  class Sound
    attr_reader :id
    attr_reader :url
    
    def initialize(id, url)
      @id = id
      @url = url
    end
  end
  
  # Represents the Javascript SoundManager2 API.  We use this class to generate Javascript
  # for an HTML ERB template that will then actually invoke the SoundManager2 API at runtime
  # in the user's browser.
  class SoundManager
    # Creates an empty SoundManager instance.
    def initialize
      @sounds = []
    end
    
    # Create a Sound object and to the list that will generate Javascript later in the #onload_function.
    def create_sound(sound_id, url)
      @sounds << Sound.new(sound_id, url)
    end
    
    # Is there a need to create an onload_function Javascript definition?
    def onload_function?
      !@sounds.empty?
    end  
    
    # Returns the Javascript code to initialize the SoundManager2 API via it's "soundManager.onload" 
    # function.  Basically, this method is called by the initialize helper methods when creating a 
    # list of sounds to play later.
    def onload_function
      output = "soundManager.onload = function() {\n"
      
      @sounds.each do |sound|
        output += %Q{\tsoundManager.createSound("#{sound.id}", "#{sound.url}");\n}
      end
      
      output += "}"
    end
  end
end