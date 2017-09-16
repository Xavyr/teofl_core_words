require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"



#add quote array for each page, break views into layut and yeilds, 
#talk to steven. 
#deploy

before do 
  @all_text = File.read("data/all_words.txt").downcase!
  @all_sentences = @all_text.split('.')
  @all_core_words = File.readlines("data/core_words.txt").map! do |word|
    word[0..-2]
  end
end

get "/" do
  erb :home
end

get "/search" do 
  @compiled_sentences = find_sentences()
  @count = get_searched_word_count()
  erb :search
end

def get_searched_word_count
  count = 0
  @all_sentences.each do |sentence|
    count += 1 if sentence.include?(@core_word)
  end
  count
end

def find_sentences
  found_sentences = []
  @core_word = params[:query]
  @all_sentences.each do |sentence|
    if sentence.include?(@core_word)
      found_sentences.push(sentence)
    end
  end
  found_sentences 
end

def highlight(text, term)
  text.gsub(term, %(<strong>#{term}</strong>))
end