require "rails_helper"

describe Events::TypeDescriptionComponent, type: "component" do
  subject! { render_inline(described_class.new(type)) }

  let(:type) { EventType.online_event_id }

  it "has a containing div" do
    expect(page).to have_css("div.type-description")
  end

  it "has an event type icon" do
    expect(page).to have_css("div.icon-online-q-a")
  end

  it "has a heading" do
    expect(page).to have_css("h5", text: "Online Q&As")
  end

  it "has a description" do
    expect(page).to have_css("p", text: I18n.t("event_types.#{type}.description.long"))
  end

  it "has a read more link" do
    expect(page).to have_link("Read more", href: "/event-categories/online-q-as", class: "type-description__link")
  end
end
