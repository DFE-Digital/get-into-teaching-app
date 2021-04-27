class FundingWidget
  include ActiveModel::Model
  include ActiveModel::Attributes

  SUBJECTS = {
    "Primary" => {
      education: "Primary",
      sub_head: "Primary",
      funding: "",
    },
    "Primary with English" => {
      education: "Primary",
      sub_head: "Primary with English",
      funding: "",
    },
    "Primary with geography and history" => {
      education: "Primary",
      sub_head: "Primary with geography and history",
      funding: "",
    },
    "Primary with mathematics" => {
      education: "Primary",
      sub_head: "Primary with mathematics",
      funding: "",
    },
    "Primary with modern languages" => {
      education: "Primary",
      sub_head: "Primary with modern languages",
      funding: "",
    },
    "Primary with physical education" => {
      education: "Primary",
      sub_head: "Primary with physical education",
      funding: "",
    },
    "Primary with science" => {
      education: "Primary",
      sub_head: "Primary with science",
      funding: "",
    },
    "Art and design" => {
      education: "Secondary",
      sub_head: "Art and design - Secondary",
      funding: "",
    },
    "Biology" => {
      education: "Secondary",
      sub_head: "Biology - Secondary",
      funding: "Bursaries of £7,000 are available for trainee biology teachers.",
    },
    "Business studies" => {
      education: "Secondary",
      sub_head: "Business - Secondary",
      funding: "",
    },
    "Chemistry" => {
      education: "Secondary",
      sub_head: "Chemistry - Secondary",
      funding: "Scholarships of £26,000 and bursaries of £24,000 are available for trainee chemistry teachers.",
    },
    "Citizenship" => {
      education: "Secondary",
      sub_head: "Citizenship - Secondary",
      funding: "",
    },
    "Classics" => {
      education: "Secondary",
      sub_head: "Classics - Secondary",
      funding: "Bursaries of £10,000 are available for trainee classics teachers.",
    },
    "Communication and media studies" => {
      education: "Secondary",
      sub_head: "Communication and media studies - Secondary",
      funding: "",
    },
    "Computing" => {
      education: "Secondary",
      sub_head: "Computing - Secondary",
      funding: "Scholarships of £26,000 and bursaries of £24,000 are available for trainee computing teachers.",
    },
    "Dance" => {
      education: "Secondary",
      sub_head: "Dance - Secondary",
      funding: "",
    },
    "Design and technology" => {
      education: "Secondary",
      sub_head: "Design and technology - Secondary",
      funding: "",
    },
    "Drama" => {
      education: "Secondary",
      sub_head: "Drama - Secondary",
      funding: "",
    },
    "Economics" => {
      education: "Secondary",
      sub_head: "Economics - Secondary",
      funding: "",
    },
    "English" => {
      education: "Secondary",
      sub_head: "English - Secondary",
      funding: "",
    },
    "Geography" => {
      education: "Secondary",
      sub_head: "Geography - Secondary",
      funding: "",
    },
    "Health and social care" => {
      education: "Secondary",
      sub_head: "Health and social care - Secondary",
      funding: "",
    },
    "History" => {
      education: "Secondary",
      sub_head: "History - Secondary",
      funding: "",
    },
    "Mathematics" => {
      education: "Secondary",
      sub_head: "Mathematics - Secondary",
      funding: "Scholarships of £26,000 and bursaries of £24,000 are available for trainee maths teachers.",
    },
    "Music" => {
      education: "Secondary",
      sub_head: "Music - Secondary",
      funding: "",
    },
    "Physical education" => {
      education: "Secondary",
      sub_head: "Physical education - Secondary",
      funding: "",
    },
    "Physics" => {
      education: "Secondary",
      sub_head: "Physics - Secondary",
      funding: "Scholarships of £26,000 and bursaries of £24,000 are available for trainee physics teachers.",
    },
    "Psychology" => {
      education: "Secondary",
      sub_head: "Psychology - Secondary",
      funding: "",
    },
    "Religious education" => {
      education: "Secondary",
      sub_head: "Religious education - Secondary",
      funding: "",
    },
    "Science" => {
      education: "Secondary",
      sub_head: "Science - Secondary",
      funding: "",
    },
    "Social sciences" => {
      education: "Secondary",
      sub_head: "Social sciences - Secondary",
      funding: "",
    },
    "English as a second or other language" => {
      education: "Secondary: Modern languages",
      sub_head: "English as a second or other language - Secondary",
      funding: "Bursaries of £10,000 are available for trainee English as a second or other language language teachers.",
    },
    "French" => {
      education: "Secondary: Modern languages",
      sub_head: "French - Secondary",
      funding: "Bursaries of £10,000 are available for trainee French language teachers.",
    },
    "German" => {
      education: "Secondary: Modern languages",
      sub_head: "German - Secondary",
      funding: "Bursaries of £10,000 are available for trainee German language teachers.",
    },
    "Italian" => {
      education: "Secondary: Modern languages",
      sub_head: "Italian - Secondary",
      funding: "Bursaries of £10,000 are available for trainee Italian language teachers.",
    },
    "Japanese" => {
      education: "Secondary: Modern languages",
      sub_head: "Japanese - Secondary",
      funding: "Bursaries of £10,000 are available for trainee Japanese language teachers.",
    },
    "Mandarin" => {
      education: "Secondary: Modern languages",
      sub_head: "Mandarin - Secondary",
      funding: "Bursaries of £10,000 are available for trainee Mandarin language teachers.",
    },
    "Modern languages (other)" => {
      education: "Secondary: Modern languages",
      sub_head: "Modern languages (other) - Secondary",
      funding: "Bursaries of £10,000 are available for trainee Modern languages (other) teachers.",
    },
    "Russian" => {
      education: "Secondary: Modern languages",
      sub_head: "Russian - Secondary",
      funding: "Bursaries of £10,000 are available for trainee Russian language teachers.",
    },
    "Spanish" => {
      education: "Secondary: Modern languages",
      sub_head: "Spanish - Secondary",
      funding: "Bursaries of £10,000 are available for trainee Spanish language teachers.",
    },
  }.freeze

  attribute :subject, :string
  validates :subject, presence: true

  def subject_data
    SUBJECTS[subject]
  end

  def subjects
    SUBJECTS
  end
end
