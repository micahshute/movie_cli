module Movies::Savable

    module ClassMethods

        def all
            self.class_variable_get("@@all")
        end

        def find_or_create_by_name(name)
            item = self.all.find{ |i| i.name == name}
            item.nil? ? self.new(name: name) : item
        end

        def find_by_name(name)
            self.all.find{|i| i.name == name}
        end

    end

    module InstanceMethods

        def save
            self.class.all << self
        end
    end

end