Rails.application.routes.draw do

	root to: 'home#index'
	# トップページのみget '/' => 'home#index'の代わりに使用
	get '/about' => 'home#about'
end
