class ListsController < ApplicationController
  def index
    @lists = List.findAll
  end

  def show
    @lists = List.find(lists_params["id"])
  end

  def update
    @lists = List.find(lists_params["id"])
    @lists.title = lists_params["title"]
    @lists.body = lists_params["body"]
    @lists.done = lists_params["done"]
    @lists.save
    redirect_to "/"
  end

  def new
  end

  def edit
    @lists = List.find(lists_params["id"])
  end

  def destroy
    List.delete(lists_params["id"])
    redirect_to "/"
  end

  def create
    @lists = List.new
    @lists.title = lists_params["title"]
    @lists.body = lists_params["body"]
    @lists.created_at = Time.now.to_s
    @lists.done = "false"
    @lists.save
    redirect_to "/"
  end

  private

  def lists_params
    params
  end
end
