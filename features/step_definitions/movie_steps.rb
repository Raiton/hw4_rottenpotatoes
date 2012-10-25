# Add a declarative step here for populating the DB with movies.

Given /^the following movies exist:$/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
    
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
end




When /^I "follow" (.*)$/ do |header|
click_link(header) 
end

Then /the director of "(.*)" should be "(.*)"$/ do |title,director|
 Movie.find_by_title(title).director==director
end

Then /I should(n't)? see: (.*)/ do |not_present, title_list|
        titles = title_list.split(", ")
        titles.each do |title|
                if page.respond_to? :should
                        if not_present then
                        page.should have_no_content(title)
               		else
                        page.should have_content(title)
                end
                else
                        if not_present then
                                assert page.has_no_content?(title)
                        else
                                assert page.has_content?(title)
                        end
                
                end
        end
end



# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  if uncheck == "un"
    rating_list.split(', ').each {|x| step %{I uncheck "ratings_#{x}"}}
  else
    rating_list.split(', ').each {|x| step %{I check "ratings_#{x}"}}
  end
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

Then /I should not see any movies/ do
  rows = page.all('#movies tr').size - 1
  assert rows == 0
end

Then /I should see all the movies/ do
  rows = page.all('#movies tr').size - 1
  assert rows == Movie.count()
end

module Enumerable
  def sorted?
    each_cons(2).all? { |a, b| (a <=> b) <= 0 }
  end
end

Then /The movies should be sorted by (.*)/ do |sorting| 
column_index= case sorting
when "title" then 0
when "release_date" then 2
else raise ArgumentError
end
values = all("table#movies tbody tr").collect { 
                |row| 
                row.all("td")[column_index].text 
        }
        
        assert values.sorted?
end


