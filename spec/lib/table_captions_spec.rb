require "rails_helper"
require "table_captions"

describe TableCaptions do
  subject { described_class.new(content).render }

  let(:content) do
    <<~HTML
      <table>
        <tr>
          <td>cell</td>
        </tr>
      </table>
      <p>Table caption: My caption</p>
    HTML
  end

  it "adds the caption to the table" do
    is_expected.to match_html(
      <<~HTML,
        <table>
          <caption>My caption</caption>
          <tr>
            <td>cell</td>
          </tr>
        </table>
      HTML
    )
  end

  context "when there are multiple tables" do
    let(:content) do
      <<~HTML
        <table></table>
        <p>Table caption: My first caption</p>
        <table></table>
        <p>Table caption: My second caption</p>
      HTML
    end

    it "adds the caption to the table" do
      is_expected.to match_html(
        <<~HTML,
          <table>
            <caption>My first caption</caption>
          </table>
          <table>
            <caption>My second caption</caption>
          </table>
        HTML
      )
    end
  end
end
