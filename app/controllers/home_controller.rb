class HomeController < ApplicationController
	def index
		# render 'home/index'が自動で反映される
		@title = 'デイトラ'
	end
	def about
	end
end