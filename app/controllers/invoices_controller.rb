class InvoicesController < ApplicationController

  def index
    @invoices = Invoice.ordered.all(:include => [ :customer, :pdf, :doc ])
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def new
    @invoice = Invoice.new(:invoice_num => Invoice.new_invoice_num)
    @invoice.pdf = Pdf.new
    @invoice.doc = Doc.new
  end

  def edit
    @invoice = Invoice.find(params[:id])
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    if params[:pdf] && params[:pdf]["uploaded_data"] != ""
      @invoice.pdf = Pdf.new(params[:pdf])
    end
    if params[:doc] && params[:doc]["uploaded_data"] != ""
      @invoice.doc = Doc.new(params[:doc])
    end

    respond_to do |format|
      if @invoice.save
        flash[:notice] = 'Rechnung erfolgreich gespeichert.'
        format.html { redirect_to(@invoice) }
        format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @invoice = Invoice.find(params[:id])
    if params[:pdf] && params[:pdf]["uploaded_data"] != ""
      @invoice.pdf = Pdf.new(params[:pdf])
    end
    if params[:doc] && params[:doc]["uploaded_data"] != ""
      @invoice.doc = Doc.new(params[:doc])
    end

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        flash[:notice] = 'Rechnung erfolgreich aktualisiert.'
        format.html { redirect_to(@invoice) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to(invoices_url) }
      format.xml  { head :ok }
    end
  end


end
