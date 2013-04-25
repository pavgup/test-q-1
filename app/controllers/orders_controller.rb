class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    @net_total = 0
    @gross_total = 0

    @order.line_item.each do |line| 
      @net_total += line.product.price
    end

    @gross_total = @net_total + @net_total * ::Rails.application.config.vat.to_d 
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => { :order => @order, :line_items => @order.line_item, :net => @net_total, :gross => @gross_total } }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(params[:order])
    respond_to do |format|
      if User.exists?(params[:order][:user_id])
        if @order.save
          format.html { redirect_to @order, notice: 'Order was successfully created.' }
          format.json { render json: @order, status: :created, location: @order }
        else
          format.html { render action: "new" }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    # @order.destroy
  
    respond_to do |format|
      format.html { redirect_to @order, notice: 'Deletion of orders not allowed.' }
      format.json { render json: @order.errors, status: :method_not_allowed }
    end
  end
  
  # GET /orders/1/place
  # GET /orders/1/place.json  
  def place
    @order = Order.find(params[:id])
    if(@order.status == "DRAFT")
      if(LineItem.where(:order_id => params[:id]).count > 0)
        @order.status = "PLACED"
        respond_to do |format|
          if @order.save
            format.html { redirect_to @order, notice: 'Order was successfully upgraded to PLACED.' }
            format.json { render json: @order, status: :accepted, location: @order }
          else
            format.html { render action: "new" }
            format.json { render json: @order.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to @order, notice: 'You must have a single line item in this order first.' }
          format.json { render json: @order.errors, status: :method_not_allowed }
        end
      end
    end
  end

  # GET /orders/1/cancel
  # GET /orders/1/cancel.json  
  # remember a note parameter must be passed with this request (e.g., /orders/1/cancel/?note=test)
  def cancel
    @order = Order.find(params[:id])
    if((@order.status == "DRAFT" || @order.status == "PLACED") && params.has_key?(:note))
      @order.cancel_note = params[:note]
      @order.status = "CANCELLED"
      if @order.save
        respond_to do |format|
          format.html { redirect_to @order, notice: 'Cancelled!'}
          format.json { render json: @order, status: :accepted, location: @order }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @order, notice: 'You must have a note param and either be in draft or placed mode.' }
        format.json { render json: @order.errors, status: :method_not_allowed }
      end
    end
  end

  # GET /orders/1/pay
  # GET /orders/1/pay.json  
  def pay
    @order = Order.find(params[:id])
    if(@order.status == "PLACED")
      @order.status = "PAID"
      if @order.save
        respond_to do |format|
          format.html { redirect_to @order, notice: 'Paid!'}
          format.json { render json: @order, status: :accepted, location: @order }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @order, notice: 'Order must first be placed before being paid.' }
        format.json { render json: @order.errors, status: :method_not_allowed }
      end
    end
  end
end
