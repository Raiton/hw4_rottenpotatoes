require 'spec_helper'

describe MoviesController do
  describe 'add director' do
    before :each do
      @m=mock(Movie, :title => "Star Wars", :director => "director", :id => "1")
      Movie.stub!(:find).with("1").and_return(@m)
    end
    it 'should call update_attributes and redirect' do
      @m.stub!(:update_attributes!).and_return(true)
      put :update, {:id => "1", :movie => @m}
      response.should redirect_to(movie_path(@m))
    end
  end
 describe 'add movie' do
  
  it 'should generate routing for creationg new movies' do
      { :post => movies_path }.
       should route_to(:controller => "movies", :action => "create")
  end
  it 'should call the the model methode create' do
    @m=mock(Movie,:title=>'Star Wars',:director=>'Raiton',:id=>'1')
    Movie.should_receive(:create!).with({"title"=>'Star Wars',"director"=>'Raiton',"id"=>'1'}).and_return(stub_model(Movie))
    post :create, :movie=>{:title=>'Star Wars',:director=>'Raiton',:id=>'1'}
    end
  it 'should redirect to the index page and show a flash message' do
   post :create, :movie=>{:title=>'Star Wars',:director=>'Raiton',:id=>'1'}
   response.should redirect_to(movies_path)
   flash[:notice].should_not be_blank
  end
end
 describe 'destroy movie' do
  before :each do
      @m=mock(Movie, :title => "Star Wars", :director => "director", :id => "1")
      Movie.stub!(:find).with("1").and_return(@m)
    end
  it 'should generate routing for deleting  movies' do
      { :delete => movie_path(@m.id) }.
       should route_to(:controller => "movies", :action => "destroy",:id=>@m.id)
  end

  it 'should redirect to the index page and show a flash message' do
   post :create, :movie=>{:title=>'Star Wars',:director=>'Raiton',:id=>'1'}
   response.should redirect_to(movies_path)
   flash[:notice].should_not be_blank
  end
  
  it 'should call the the model methode destroy' do
    @m.should_receive(:destroy)
    delete :destroy, :id=>@m.id
    end

end
  






 describe 'find movies with same director happy path'do
  before :each do
   @m=mock(Movie,:title=>'Star Wars',:director=>'Raiton',:id=>'1')
   Movie.stub!(:find).with("1").and_return(@m)
   end
  it 'should generate routing for Similar Movies' do
      { :post => movie_similar_director_path(1) }.
       should route_to(:controller => "movies", :action => "similar_director", :movie_id => "1")
  end
  it 'should call the method "similar_directors" of the Movie model with the director as param ' do
    fake_results = [mock('Movie'), mock('Movie')]
      Movie.should_receive(:similar_directors).with('Raiton').and_return(fake_results)
      get :similar_director, :movie_id => "1"
    end
  it 'should choose the template similar_director' do
      Movie.stub!(:similar_directors).with('Raiton').and_return(@m)
      get :similar_director, :movie_id => "1"
      response.should render_template('similar_director')
      assigns(:movies).should == @m

  end
end

 describe 'find movies with same director sad path'do
   before :each do
   @m=mock(Movie,:title=>'Star Wars',:director=>nil,:id=>'1')
   Movie.stub!(:find).with("1").and_return(@m)
   end
 it 'should generate routing for Similar Movies' do
      { :post => movie_similar_director_path(1) }.
       should route_to(:controller => "movies", :action => "similar_director", :movie_id => "1")
  end
  it 'should redirect to the index page and show a flash message' do
   get :similar_director, :movie_id => "1"
   response.should redirect_to(movies_path)
   flash[:notice].should_not be_blank
  end
  
























end

end
