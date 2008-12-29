class SoundManager2Generator < Rails::Generator::Base
  def manifest
    record do |m|
      # put the Flash file in place
      m.file 'soundmanager2.swf', 'public/soundmanager2.swf'
      
      # copy over the Javascript files
      m.file 'soundmanager2.js',       'public/javascripts/soundmanager2.js'
      m.file 'soundmanager2-jsmin.js', 'public/javascripts/soundmanager2-jsmin.js'
      m.file 'soundmanager2-rails.js', 'public/javascripts/soundmanager2-rails.js'
      
      # setup the handy-dandy throw-away images
      m.directory "public/images/SoundManager2"
      m.file 'SoundManager2-images/pause-control.gif', 'public/images/SoundManager2/pause-control.gif'
      m.file 'SoundManager2-images/play-control.gif', 'public/images/SoundManager2/play-control.gif'
    end
  end
end
