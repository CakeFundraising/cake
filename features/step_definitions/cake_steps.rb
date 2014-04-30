Given(/^(\d+) (.*?) of that (.*?) exist$/) do |quantity, model, role|
  model = model.singularize.tr(' ', '_')
  instance_variable_set("@#{model.pluralize}", FactoryGirl.create_list(model.to_sym, quantity.to_i, role.to_sym => model(role.to_sym)))
end

Given(/^(?:a|an) (.*?) of that (.*?) exists(?: with (.*?))?$/) do |model, parent, fields|
  if fields.present?
    parent = parent + ': model("' + parent + '")'
    fields = '{' << fields << ', ' << parent << '}'
    model = model.tr(' ', '_')
    instance_variable_set("@#{model}", FactoryGirl.create(model.to_sym, eval(fields) ))
  else
    model = model.tr(' ', '_')
    parent_obj =  model(parent.to_sym) || eval("@#{parent.tr(' ', '_')}").reload
    instance_variable_set("@#{model}", FactoryGirl.create(model.to_sym, parent.to_sym => parent_obj ))
  end
end

Then(/^the (.*?) should have a "(.*?)" status$/) do |model, status|
  eval("@#{model.tr(' ', '_')}").reload.status.should == status
end
