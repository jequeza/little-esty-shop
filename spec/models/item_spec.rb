require 'rails_helper'

RSpec.describe Item, type: :model do
  before :each do
    @customer1 = Customer.create(first_name: "Joe", last_name: "Smith")
    @merchant1 = Merchant.create(name: "Pawtrait Designs")
    @item1 = @merchant1.items.create(name: "Puppy Portrait",
                                     description: "Wall art of your favorite pup",
                                     unit_price: 10.99, status: "Active")
    @item2 = @merchant1.items.create(name: "Kitty Portrait",
                                     description: "5x7 of your favorite cat",
                                     unit_price: 6.99, status: "Inactive")
    @item3 = @merchant1.items.create(name: "Pet Portrait",
                                     description: "8x10 of all your favorite pets",
                                     unit_price: 8.99, status: "Active")
    @invoice1 = @customer1.invoices.create(status: 2)
    @invoice2 = @customer1.invoices.create(status: 2)
    @invoice3 = @customer1.invoices.create(status: 2)
    @invoice_item1 = InvoiceItem.create(item_id: @item1.id,
                                        invoice_id: @invoice1.id,
                                        quantity: 100,
                                        unit_price: 10.99,
                                        status: 0)
    @invoice_item2 = InvoiceItem.create(item_id: @item1.id,
                                        invoice_id: @invoice1.id,
                                        quantity: 100,
                                        unit_price: 10.99,
                                        status: 2)
    @invoice_item3 = InvoiceItem.create(item_id: @item2.id,
                                        invoice_id: @invoice2.id,
                                        quantity: 500,
                                        unit_price: 6.99,
                                        status: 1)
  end

  describe "relationships" do
    it { should belong_to :merchant }
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:bulk_discounts).through(:merchant)}
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
  end

  describe "class methods" do
    describe "::active" do
      it "can show an item status as active if it has been enabled" do
        expect(Item.active).to eq([@item1, @item3])
        expect(Item.active).to_not eq([@item2])
      end
    end

    describe "::inactive" do
      it "can show an item status as inactive if it has been disabled" do
        expect(Item.inactive).to eq([@item2])
        expect(Item.inactive).to_not eq([@item1, @item3])
      end
    end
  end

  describe "instance methods" do
    describe "#top_sales_date" do
      it "can return the date formatted as mm/dd/yyyy for the top item's best sales date" do
        expect(@item1.top_sales_date).to eq("#{@invoice1.created_at.strftime('%m/%d/%Y')}")
        expect(@item1.top_sales_date.class).to eq(String)
      end
    end
  end
end
