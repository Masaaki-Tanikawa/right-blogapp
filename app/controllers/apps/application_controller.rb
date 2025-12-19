class Apps::ApplicationController < ApplicationController
  before_action :authenticate_user! # apps内のコントローラーは、すべてログインしないと使えないようにする
end