require "rails_helper"

describe "Accessible footnotes", type: :request do
  before do
    get "/content-page"
  end

  subject { response.body }

  it "makes footnotes accessible" do
    is_expected.to include(%(<a href="#fn:1" class="footnote" rel="footnote"><span class="visually-hidden">Footnote </span>1</a>))
    is_expected.to include(%(<a href="#fn:2" class="footnote" rel="footnote"><span class="visually-hidden">Footnote </span>2</a>))

    is_expected.to include(%(<a href="#fnref:1" class="reversefootnote" role="doc-backlink"><span class="visually-hidden">Location of footnote 1</span>↩</a>))
    is_expected.to include(%(<a href="#fnref:2" class="reversefootnote" role="doc-backlink"><span class="visually-hidden">Location of footnote 2</span>↩</a>))
  end
end
