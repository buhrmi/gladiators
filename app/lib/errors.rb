module Errors
  class GameError < StandardError
    def initialize(message, **args)
      super(I18n.t(message, **args))
    end
  end
end
