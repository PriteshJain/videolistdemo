class Entry < ApplicationRecord
  has_attached_file :video, :styles => {
									  	mobile: { format: "mp4",
									  		:streaming => true,
										    convert_options: {
										      output: {
									          vcodec: 'mpeg4',
									          acodec: 'aac'
										      }
										    }
										  },
									    :thumb => { :geometry => "853x480#", :format => 'jpg', :time => 1 }
								  }, :processors => [:transcoder]

	validates_attachment_content_type :video, :content_type => /\Avideo\/.*\Z/
	validate :file_size_validation, :if => "video?"
  validates_presence_of :video
  belongs_to :user

	def file_size_validation
		errors[:video] << "should be atleast for a sec" if video.size.to_i < 1.kilobytes
    errors[:video] << "should be less than 50MB" if video.size.to_i > 50.megabytes
  end
end


# ffmpeg -i INPUT -map_channel 0.0.1 -map_channel 0.0.0 OUTPUT
