class SoundPlayer
  def self.instance
    Dispatch.once { @instance ||= new }
    @instance
  end

  def play_sound(file_name)
    @sound.stop if @sound

    url = NSURL.fileURLWithPath(File.join(NSBundle.mainBundle.resourcePath, "sounds/#{file_name}"))

    @sound = AVAudioPlayer.alloc.initWithContentsOfURL(url, error:nil)
    @sound.play
    @sound.volume = 1
  end

  def mute(steps = 20, &block)
    return unless @sound

    step = 1
    volumeStep = @sound.volume / steps
    timer = EM.add_periodic_timer 0.1 do
      step += 1
      @sound.volume -= volumeStep

      if step > steps
        @sound.stop
        EM.cancel_timer(timer)

        block.call if block.present? && block.respond_to?(:call)
      end
    end
  end
end