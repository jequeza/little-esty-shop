require 'rails_helper'

RSpec.describe "Merchant Invoice Show Page" do
  before :each do
    @merchant = Merchant.create(name: "John's Jewelry")
    @savy_merchant = Merchant.create(name: "Save Lotz")
    @discount1 = @savy_merchant.bulk_discounts.create(quantity_treshold: 500, percentage_discount: 25)
    @discount2 = @savy_merchant.bulk_discounts.create(quantity_treshold: 400, percentage_discount: 20)
    @discount3 = @savy_merchant.bulk_discounts.create(quantity_treshold: 1200, percentage_discount: 50)
    @discount4 = @savy_merchant.bulk_discounts.create(quantity_treshold: 150, percentage_discount: 5)
    @not_merchant = Merchant.create(name: "Mikey Mouse Rings")
    @not_item = @not_merchant.items.create(name: "Mouse Ring", description: "Oh Toodles", unit_price: 12.99)
    @item_lot = @savy_merchant.items.create(name: "USB Chargers", description: "Latest Model USB", unit_price: 15.99)
    @network_cables = @savy_merchant.items.create(name: "Network Cables", description: "2ft Long High Quality Cable", unit_price: 20.99)

    @item1 = @merchant.items.create(name: "Gold Ring", description: "14K Wedding Band",
                                  unit_price: 599.95)
    @item2 = @merchant.items.create(name: "Pearl Necklace", description: "Beautiful White Pearls",
                                  unit_price: 250.00)
    @customer = Customer.create!(first_name: "Bob", last_name: "Jones")
    @john = Customer.create!(first_name: "John", last_name: "Kelley")
    @not_customer = Customer.create!(first_name: "Mike", last_name: "Jones")
    @invoice1 = @customer.invoices.create(status: 0)
    @invoice2 = @customer.invoices.create(status: 1)
    @discount_invoice = @john.invoices.create(status: 1)
    @invoice_item1 = InvoiceItem.create!(invoice_id: @invoice1.id,
                                       item_id: @item1.id, quantity: 500,
                                       unit_price: 599.95, status: 0)
    @invoice_item2 = InvoiceItem.create!(invoice_id: @invoice1.id,
                                       item_id: @item2.id, quantity: 2,
                                       unit_price: 250.00, status: 0)
    @not_invoice_item = InvoiceItem.create!(invoice_id: @invoice2.id,
                                       item_id: @not_item.id, quantity: 976,
                                       unit_price: 10.00, status: 1)
    @johns_invoice_item = InvoiceItem.create!(invoice_id: @discount_invoice.id,
                                       item_id: @item_lot.id, quantity: 500,
                                       unit_price: 15.99, status: 2)
    @johns_invoice_item2 = InvoiceItem.create!(invoice_id: @discount_invoice.id,
                                          item_id: @network_cables.id, quantity: 200,
                                          unit_price: 20.99, status: 2)
    @johns_invoice_item3 = InvoiceItem.create!(invoice_id: @discount_invoice.id,
                                          item_id: @item2.id, quantity: 5,
                                          unit_price: 100, status: 2)

  end
  describe "When I visit my merchant's invoice show page(/merchants/merchant_id/invoices/invoice_id)" do
    it "I see the invoice attributes listed" do
      visit "/merchant/#{@merchant.id}/invoices/#{@invoice1.id}"
        within "#invoice-info" do
          expect(page).to have_content(@invoice1.id)
          expect(page).to have_content(@invoice1.status_format)
          expect(page).to have_content(@invoice1.date_format)
        end
    end
    it "I see all of the customer information related to that invoice " do
      visit "/merchant/#{@merchant.id}/invoices/#{@invoice1.id}"
        within "#invoice-customer-info" do
          expect(page).to have_content(@customer.name)
          expect(page).to_not have_content(@not_customer.name)
        end
    end
    it "Then I see all of my items on the invoice(item name, quantity, price sold, invoice item status)" do
      visit "/merchant/#{@merchant.id}/invoices/#{@invoice1.id}"
        expect(page).to_not have_content(@not_item.name)
        expect(page).to_not have_content(@not_invoice_item.quantity)
        expect(page).to_not have_content(@not_invoice_item.unit_price)

        within "#invoice-items-#{@invoice_item1.id}-info" do
          expect(page).to have_content(@item1.name)
          expect(page).to have_content(@invoice_item1.quantity)
          expect(page).to have_content(@invoice_item1.unit_price)
          expect(page).to have_content(@invoice_item1.status.titleize)
        end
        within "#invoice-items-#{@invoice_item2.id}-info" do
          expect(page).to have_content(@item2.name)
          expect(page).to have_content(@invoice_item2.quantity)
          expect(page).to have_content(@invoice_item2.unit_price)
          expect(page).to have_content(@invoice_item2.status.titleize)
        end
    end
    it "I see the total revenue that will be generated from all of my items on the invoice" do
      visit "/merchant/#{@merchant.id}/invoices/#{@invoice1.id}"
        within "#invoice-total-revenue" do
          expect(page).to have_content(@invoice1.total_revenue)
        end
    end
    it "I see that each invoice item status is a select field and can be updated with a button" do
      visit "/merchant/#{@merchant.id}/invoices/#{@invoice1.id}"
        within "#invoice-items-#{@invoice_item1.id}-info" do
          expect(page).to have_button("Update Item Status")
          select('Shipped', from: 'status')
          click_button("Update Item Status")
          expect(current_path).to eq("/merchant/#{@merchant.id}/invoices/#{@invoice1.id}")
          expect(page).to have_content('Shipped')
        end
    end
    it "I see that the total revenue for my merchant includes bulk discounts in the calculation" do
      visit "/merchant/#{@merchant.id}/invoices/#{@discount_invoice.id}"
        within "#invoice-total-revenue" do
          expect(page).to have_content(@discount_invoice.total_revenue_with_discount)
          expect(page).to_not have_content(@invoice1.total_revenue_with_discount)
          expect(page).to_not have_content(@invoice2.total_revenue_with_discount)
        end
    end
    it "Next to each invoice item I see a link to the show page for the bulk discount that was applied if any" do
      visit "/merchant/#{@merchant.id}/invoices/#{@discount_invoice.id}"
        within "#bulk-discount-#{@discount1.id}" do
          expect(page).to have_content("View Discount # #{@discount1.id} Applied")
          expect(page).to_not have_content("View Discount # #{@discount3.id} Applied")
        end
    end
  end
end
