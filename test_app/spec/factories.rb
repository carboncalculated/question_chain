# Read about factories at http://github.com/thoughtbot/factory_girl
Factory.sequence :name do |n|
  "name_#{n}"
end

Factory.sequence :object_name do |n|
  "object_name_#{n}"
end

Factory.sequence :label do |n|
  "label_#{n}"
end

Factory.sequence :related_attribute do |n|
  "related_attribute_#{n}"
end

Factory.define :user do |f|
  f.name {Factory.next(:name)}
end

Factory.define :flight do |f|
  f.question_id {BSON::ObjectId.new}
  f.result{ {"co2"=> "45.5", "object_references" => {"123" => {"identifier" => "beans"}}}}
  f.answer_params {{"flight" => "123"}}
  f.reference {Factory.next(:name)}
  f.association :user
end

Factory.define :chain_template do |f|
  f.for_resource "container"
end

Factory.define :question do |f|
  f.name {Factory.next(:name)}
  f.label {Factory.next(:label)}
  f.description "this is a question it can be about anything that is carbon"
end

Factory.define :ui_group do |f|
  f.name {Factory.next(:name)}
  f.label {Factory.next(:label)}
  f.description "this is a question it can be about anything that is carbon"
  f.association :question
end

Factory.define :ui_object do |f|
  f.label {Factory.next(:label)}
  f.association :ui_group
end

Factory.define :drop_down, :class => UiObjects::DropDown do |f|
  f.label {Factory.next(:label)}
  f.association :ui_group
  f.options {%w(what ever the egg says is true)}
end

Factory.define :check_box, :class => UiObjects::CheckBox do |f|
  f.label {Factory.next(:label)}
  f.association :ui_group
end

Factory.define :hidden_field, :class => UiObjects::HiddenField do |f|
  f.label {Factory.next(:label)}
  f.association :ui_group
end

Factory.define :object_reference_drop_down, :class => UiObjects::ObjectReferenceDropDown do |f|
  f.label {Factory.next(:label)}
  f.association :ui_group
  f.object_name {Factory.next(:object_name)}
end

Factory.define :relatable_category_drop_down, :class => UiObjects::RelatableCategoryDropDown do |f|
  f.association :ui_group
  f.label {Factory.next(:label)}
  f.related_attribute {Factory.next(:related_attribute)}
  f.object_name {Factory.next(:object_name)}
end

Factory.define :text_field, :class => UiObjects::TextField do |f|
  f.association :ui_group
  f.label {Factory.next(:label)}
end


