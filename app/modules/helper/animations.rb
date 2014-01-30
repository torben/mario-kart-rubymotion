module Helper
  module Animations
    def wubbel(view, &block)
      animate_duration = 0.08

      UIView.animateWithDuration(animate_duration, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
        view.transform = CGAffineTransformMakeScale(0.9, 0.9)
      }, completion: lambda { |completed|
        UIView.animateWithDuration(animate_duration, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
          view.transform = CGAffineTransformMakeScale(1.08, 1.08)
        }, completion: lambda { |completed|
          UIView.animateWithDuration(animate_duration, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
            view.transform = CGAffineTransformMakeScale(0.95, 0.95)
          }, completion: lambda { |completed|
            UIView.animateWithDuration(0.11, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
              view.transform = CGAffineTransformMakeScale(1.03, 1.03)
            }, completion: lambda { |completed|
              UIView.animateWithDuration(0.11, delay:0, options:UIViewAnimationOptionCurveEaseInOut, animations: lambda {
                view.transform = CGAffineTransformIdentity
              }, completion: lambda { |completed|
                block.call if block.present? && block.respond_to?(:call)
              })
            })
          })
        })
      })
    end
  end
end