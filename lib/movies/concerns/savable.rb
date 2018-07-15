module Movies::Savable

    module ClassMethods

        def all
            self.class_variable_get("@@all")
        end

        

    end

    module InstanceMethods

        def save
            self.class.all << self
        end
    end

end