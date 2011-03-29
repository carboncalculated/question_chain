class UiObjectAnswer  
  
  # @todo refactor make not as ugly as a bulldog eating a wasp
  # @param [String] json
  # @return [String] json formatted String manipulate from ui changes
  def self.update_answers!(answer_json = "")
    @answer_hash = JSON.parse(answer_json)
    if  @ui_objects = @answer_hash.delete("ui_objects")
        uis = UiObject.find(ui_object_ids)
        uis.each do |ui_object|
          ui_object.change_value!(@ui_objects)
        end
    end    
    @answer_hash["ui_objects"] = @ui_objects
    answer_json = @answer_hash.to_json
  end
end