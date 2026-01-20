module MailingListHelper
  include GraduationYearMethods

  attr_reader  :degree_status, :graduation_year,
               :citizenship, :visa_status, :location,
               :situation, :consideration_journey_stage, :teaching_subject

  def ml_uk_citizen?
    citizenship && citizenship.id == MailingList::Steps::Citizenship::UK_CITIZEN
  end

  def ml_non_uk_citizen?
    citizenship && citizenship.id == MailingList::Steps::Citizenship::NON_UK_CITIZEN
  end

  def ml_career_changer?
    situation && situation.id == MailingList::Steps::LifeStage::CAREER_CHANGER
  end

  def ml_has_degree?
    degree_status && degree_status.id == MailingList::Steps::DegreeStatus::HAS_DEGREE
  end

  def ml_degree_in_progress?
    degree_status && degree_status.id == MailingList::Steps::DegreeStatus::DEGREE_IN_PROGRESS
  end

  def ml_no_degree?
    degree_status && degree_status.id == MailingList::Steps::DegreeStatus::NO_DEGREE
  end

  def ml_high_commitment?
    consideration_journey_stage && consideration_journey_stage.id == MailingList::Steps::TeacherTraining::HIGH_COMMITMENT
  end

  def ml_graduated_and_exploring_career_options?
    situation && situation.id == MailingList::Steps::LifeStage::GRADUATED_AND_EXPLORING_CAREER_OPTS
  end

  def ml_explore_subject?
    ml_explore_subject.present?
  end

  def ml_explore_subject
    return unless teaching_subject
    case teaching_subject.id
    when Crm::TeachingSubject::ART_AND_DESIGN
      link_to "teaching art and design", "/life-as-a-teacher/explore-subjects/art-and-design"
    when Crm::TeachingSubject::BIOLOGY
      link_to "teaching biology", "/life-as-a-teacher/explore-subjects/biology"
    when Crm::TeachingSubject::BUSINESS
      link_to "teaching business", "/life-as-a-teacher/explore-subjects/business"
    when Crm::TeachingSubject::CHEMISTRY
      link_to "teaching chemistry", "/life-as-a-teacher/explore-subjects/chemistry"
    when Crm::TeachingSubject::COMPUTING
      link_to "teaching computing", "/life-as-a-teacher/explore-subjects/computing"
    when Crm::TeachingSubject::DESIGN_AND_TECHNOLOGY
      link_to "teaching design and technology", "/life-as-a-teacher/explore-subjects/design-and-technology"
    when Crm::TeachingSubject::DRAMA
      link_to "teaching drama", "/life-as-a-teacher/explore-subjects/drama"
    when Crm::TeachingSubject::ENGLISH
      link_to "teaching English", "/life-as-a-teacher/explore-subjects/english"
    when Crm::TeachingSubject::GEOGRAPHY
      link_to "teaching geography", "/life-as-a-teacher/explore-subjects/geography"
    when Crm::TeachingSubject::HISTORY
      link_to "teaching history", "/life-as-a-teacher/explore-subjects/history"
    when Crm::TeachingSubject::MATHS
      link_to "teaching maths", "/life-as-a-teacher/explore-subjects/maths"
    when Crm::TeachingSubject::MUSIC
      link_to "teaching music", "/life-as-a-teacher/explore-subjects/music"
    when Crm::TeachingSubject::PHYSICAL_EDUCATION
      link_to "teaching physical education", "/life-as-a-teacher/explore-subjects/physical-education"
    when Crm::TeachingSubject::PHYSICS
      link_to "teaching physics", "/life-as-a-teacher/explore-subjects/physics"
    when Crm::TeachingSubject::RELIGIOUS_EDUCATION
      link_to "teaching religious education", "/life-as-a-teacher/explore-subjects/religious-education"
    when Crm::TeachingSubject::FRENCH, Crm::TeachingSubject::GERMAN, Crm::TeachingSubject::SPANISH, Crm::TeachingSubject::LANGUAGES_OTHER
      link_to "teaching languages", "/life-as-a-teacher/explore-subjects/languages"
    when Crm::TeachingSubject::PRIMARY
      link_to "teaching primary education", "/life-as-a-teacher/age-groups-and-specialisms/primary"
    end
  end
end
