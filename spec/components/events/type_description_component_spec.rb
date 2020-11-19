require "rails_helper"

describe Events::TypeDescriptionComponent, type: "component" do
  let(:type) { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online Event"] }

  subject! { render_inline(Events::TypeDescriptionComponent.new(type)) }

  it "has a containing div" do
    expect(page).to have_css("div.type-description")
  end

  it "has an event type icon" do
    expect(page).to have_css("div.icon-online-event")
  end

  it "has a heading" do
    expect(page).to have_css("h5", text: "Online Events")
  end

  it "has a description" do
    expect(page).to have_css("p", text: I18n.t("event_types.#{type}.description"))
  end

  it "has a read more link" do
    expect(page).to have_link("Read more", href: "/events/category/online-events", class: "type-description__link")
  end
end
