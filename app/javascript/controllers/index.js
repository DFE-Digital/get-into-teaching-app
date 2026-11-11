// Controller identifiers follow the Stimulus convention: strip `_controller`
// and turn underscores into hyphens.
import { Application } from '@hotwired/stimulus';

import abbreviationController from './abbreviation_controller';
import accordionController from './accordion_controller';
import badgeController from './badge_controller';
import bannerController from './banner_controller';
import chatController from './chat_controller';
import conditionalFieldController from './conditional_field_controller';
import cookieAcceptanceController from './cookie-acceptance_controller';
import cookiePreferencesController from './cookie_preferences_controller';
import feedbackController from './feedback_controller';
import fundingWidgetController from './funding_widget_controller';
import internalEventsController from './internal_events_controller';
import lastStepController from './last_step_controller';
import linkController from './link_controller';
import navigationController from './navigation_controller';
import patchAutocompleteController from './patch_autocomplete_controller';
import tableController from './table_controller';
import whatSubjectDegreeController from './what_subject_degree_controller';

const application = Application.start();

application.register('abbreviation', abbreviationController);
application.register('accordion', accordionController);
application.register('badge', badgeController);
application.register('banner', bannerController);
application.register('chat', chatController);
application.register('conditional-field', conditionalFieldController);
application.register('cookie-acceptance', cookieAcceptanceController);
application.register('cookie-preferences', cookiePreferencesController);
application.register('feedback', feedbackController);
application.register('funding-widget', fundingWidgetController);
application.register('internal-events', internalEventsController);
application.register('last-step', lastStepController);
application.register('link', linkController);
application.register('navigation', navigationController);
application.register('patch-autocomplete', patchAutocompleteController);
application.register('table', tableController);
application.register('what-subject-degree', whatSubjectDegreeController);
