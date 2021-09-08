require "rails_helper"

describe Events::SearchComponent, type: "component" do
  let(:search) { build(:events_search, :invalid) }
  let(:path) { "/some/path" }

  let(:component) { described_class.new(search, path) }

  subject! { render_inline(component) }

  before { freeze_time }

  specify "builds a search form" do
    expect(page).to have_css("form[action='#{path}'][method='get']")
  end

  describe "heading" do
    context "when unset" do
      specify %(the title is 'Search for events') do
        expect(page).to have_css("h2", text: "Search for events")
      end
    end

    context "when overridden" do
      let(:new_heading) { "Search for Awesome events" }

      subject! { render_inline(described_class.new(search, path, heading: new_heading)) }

      specify %(the title is overridden) do
        expect(page).to have_css("h2", text: new_heading)
      end
    end
  end

  describe "error messages" do
    specify "any error messages should be rendered" do
      component.error_messages.each do |message|
        expect(page).to have_css("div", text: message)
      end
    end
  end

  describe "fields" do
    [
      { attribute: :type, label: "Event type", element: :select },
      { attribute: :distance, label: "Distance", element: :select },
      { attribute: :postcode, label: "Postcode", element: :input },
      { attribute: :month, label: "Month", element: :select },
    ].each do |field|
      describe field[:label] do
        specify "is present" do
          expect(page).to have_css("#{field[:element]}[name='events_search[#{field[:attribute]}]']")
        end

        specify "is correctly-labelled" do
          expect(page).to have_css("label[for='events_search_#{field[:attribute]}']")
          expect(page).to have_css("#{field[:element]}[id='events_search_#{field[:attribute]}']")
        end
      end
    end

    it "only shows the next 6 months in the month field" do
      months = page.find_field("Month").find_all("option").map(&:text)
      expected_months = (0..5).map do |i|
        i.months.from_now.to_date.to_formatted_s(:humanmonthyear)
      end

      expect(months).to eq(expected_months)
    end

    describe "optionally-blank month field" do
      subject! { render_inline(described_class.new(search, path, allow_blank_month: true)) }

      specify "there should be a blank option with the text '#{described_class::BLANK_MONTH_TEXT}'" do
        expect(page).to have_css("option[value='']", text: described_class::BLANK_MONTH_TEXT)
      end
    end
  end
end
