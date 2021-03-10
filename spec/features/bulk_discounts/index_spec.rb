require 'rails_helper'

RSpec.describe "Index Page" do
  before :each do
    @merchant1 = create(:merchant)
    @merchant1_bulk_discount1 = create(:bulk_discount, merchant_id: @merchant1.id, quantity_treshold: 2, percentage_discount: 50)
    @merchant1_bulk_discount2 = create(:bulk_discount, merchant_id: @merchant1.id, quantity_treshold: 100, percentage_discount: 30)
    @merchant1_bulk_discount3 = create(:bulk_discount, merchant_id: @merchant1.id, quantity_treshold: 50, percentage_discount: 15)
    @merchant2 = create(:merchant)
    @merchant2_bulk_discount1 = create(:bulk_discount, merchant_id: @merchant2.id, quantity_treshold: 10, percentage_discount: 10)
  end
  describe "As a merchant" do
    describe "When I visit my merchant dashboard" do
      it "I see a link to view all my discounts and I am taken to the bulk discounts index page once I click link" do
        visit "/merchant/#{@merchant1.id}/dashboard"
          within "#links" do
            expect(page).to have_link("My Bulk Discounts")
            click_on("My Bulk Discounts")
            expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts")
          end
      end
      it "I see all of my bulk discounts including their attributes" do
        visit "/merchant/#{@merchant1.id}/bulk_discounts"
          within "#all-merchant-bulk-discounts" do
            within "#bulk-discount-#{@merchant1_bulk_discount1.id}-info" do
              expect(page).to have_content(@merchant1_bulk_discount1.quantity_treshold)
              expect(page).to have_content(@merchant1_bulk_discount1.percentage_discount)
              expect(page).to have_content(@merchant1_bulk_discount1.id)
              expect(page).to_not have_content(@merchant2_bulk_discount1.id)
            end
            within "#bulk-discount-#{@merchant1_bulk_discount2.id}-info" do
              expect(page).to have_content(@merchant1_bulk_discount2.quantity_treshold)
              expect(page).to have_content(@merchant1_bulk_discount2.percentage_discount)
              expect(page).to have_content(@merchant1_bulk_discount2.id)
              expect(page).to_not have_content(@merchant2_bulk_discount1.id)
            end
            within "#bulk-discount-#{@merchant1_bulk_discount3.id}-info" do
              expect(page).to have_content(@merchant1_bulk_discount3.quantity_treshold)
              expect(page).to have_content(@merchant1_bulk_discount3.percentage_discount)
              expect(page).to have_content(@merchant1_bulk_discount3.id)
              expect(page).to_not have_content(@merchant2_bulk_discount1.id)
            end
            expect(page).to_not have_content(@merchant2_bulk_discount1.id)
          end
      end
      it "each bulk discount listed includes a link to its show page" do
        visit "/merchant/#{@merchant1.id}/bulk_discounts"
          within "#all-merchant-bulk-discounts" do
            expect(page).to have_link("View Bulk Discount # #{@merchant1_bulk_discount1.id}")
            expect(page).to have_link("View Bulk Discount # #{@merchant1_bulk_discount2.id}")
            expect(page).to have_link("View Bulk Discount # #{@merchant1_bulk_discount3.id}")
            expect(page).to_not have_link("View Bulk Discount # #{@merchant2_bulk_discount1.id}")
          end
      end
    end
    describe "I visit my bulk discounts index" do
      describe "Then next to each bulk discount I see a link to delete it" do
        it "I can delete the bulk discount by clicking the link" do
          visit "/merchant/#{@merchant1.id}/bulk_discounts"
            within "#all-merchant-bulk-discounts" do
              expect(page).to have_link("Delete Bulk Discount # #{@merchant1_bulk_discount1.id}")
              expect(page).to have_link("Delete Bulk Discount # #{@merchant1_bulk_discount2.id}")
              expect(page).to have_link("Delete Bulk Discount # #{@merchant1_bulk_discount3.id}")
              expect(page).to_not have_link("Delete Bulk Discount # #{@merchant2_bulk_discount1.id}")
              click_link("Delete Bulk Discount # #{@merchant1_bulk_discount1.id}")
              expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts")
              expect(page).to_not have_link("Delete Bulk Discount # #{@merchant1_bulk_discount1.id}")
            end
        end
      end
      describe "Upcoming holidays are listed in the index page" do
        it "Upcoming holidays can be seen on the index page" do
          visit "/merchant/#{@merchant1.id}/bulk_discounts"
            within "#upcoming-holidays" do
              expect(page).to have_content("Upcoming US Holidays")
            end
        end
      end
    end
  end
end