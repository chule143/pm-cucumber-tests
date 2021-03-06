When /^Open a new (.*) pop-up$/ do |object|
  @home.open_dialog object
end

Then /^Fill the required fields$/ do
  @_process_name = "Process-" +(Time.now.to_i%1000000).to_s
  @_process_desc = "Testing "+@_process_name
  @_process_category = "No Category"
  @home.designer_iframe do |designer_frame|
    @home.fill_field designer_frame.new_process_dialog.process_name, @_process_name
    @home.fill_field designer_frame.new_process_dialog.process_description, @_process_desc
    #@home.fill_field designer_frame.new_process_dialog.process_category_dd, @_process_category
  end
end

And /^Create the (.*) clicking on the 'Create' button$/ do |object|
  @home.designer_iframe do |designer_frame|
    designer_frame.new_process_dialog.create_process.click

    designer_frame.process_submenu.wait_for_dynaforms(5)
    designer_frame.process_submenu.wait_until_dynaforms_visible(5)
    expect(designer_frame.process_submenu.has_dynaforms?).to eq(true)
  end
end

Then /^The (.*) just created should be displayed in the list$/ do |object|
  @home.go_to_menu "DESIGNER"
  @home.designer_iframe do |designer_frame|
    designer_frame.wait_for_new_process_button(5)
    designer_frame.wait_until_new_process_button_visible(5)
    expect(designer_frame.has_new_process_button?).to eq(true)

    @home.fill_field designer_frame.search_process_field, @_process_name
    designer_frame.search_process_button.click
    sleep(5)

    designer_frame.first_checkbox_of_table.set(true)
  end
end