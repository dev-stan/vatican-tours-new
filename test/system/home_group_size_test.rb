require "application_system_test_case"

class HomeGroupSizeTest < ApplicationSystemTestCase
  test "the travellers picker reprices the tour cards and is kept in the address" do
    visit root_path
    ancient = find("article", text: tours(:ancient_rome).title)
    food = find("article", text: tours(:food_tour).title)
    assert_selector "article", text: /Private\s*€390\s*\|\s*Group\s*€65/

    click_button "1 traveller"
    3.times { find("button[aria-label='More adults']").click }
    within(ancient) { assert_text(/Private\s*€390\s*\|\s*Group\s*€260/) }
    assert_button "4 travellers"
    assert_current_path root_path(guests: 4)

    2.times { find("button[aria-label='More children']").click }
    4.times { find("button[aria-label='More adults']").click }
    within(ancient) { assert_text(/Private\s*max 8\s*\|\s*Group\s*€650/) }
    within(food) { assert_text(/Private\s*max 6/) }
    assert_current_path "/?guests=10&children=2"

    click_button "Done"
    assert_no_selector "#travellers-panel"

    click_button "10 travellers"
    2.times { find("button[aria-label='Fewer children']").click }
    7.times { find("button[aria-label='Fewer adults']").click }
    assert_selector "button[aria-label='Fewer adults'][disabled]"
    within(ancient) { assert_text(/Private\s*€390\s*\|\s*Group\s*€65/) }
    within(food) { assert_text(/Private\s*€500/) }
    assert_current_path root_path
  end

  test "tour type chips filter the cards" do
    visit root_path
    click_button "Food and Cooking"
    assert_selector "button[aria-pressed=true]", text: "Food and Cooking"
    assert_no_selector "article", text: tours(:ancient_rome).title
  end
end
