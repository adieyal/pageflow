import Backbone from 'backbone';

import {
  EditConfigurationView,
  configurationContainer,
  failureTracking
} from 'pageflow/editor';

import {TextInputView} from 'pageflow/ui';
import {ConfigurationEditor} from '$support/dominos/ui';
import * as support from '$support';

describe('EditConfigurationView', () => {
  it('renders configuration editor with inputs defined in configure method', () => {
    const Model = Backbone.Model.extend({
      mixins: [configurationContainer(), failureTracking]
    });
    const View = EditConfigurationView.extend({
      configure(configurationEditor) {
        configurationEditor.tab('general', function() {
          this.input('title', TextInputView);
        });
      }
    });

    const view = new View({model: new Model()}).render();
    const configurationEditor = ConfigurationEditor.find(view);

    expect(configurationEditor.inputPropertyNames()).toContain('title');
  });

  describe('translationKeyPrefix', () => {
    support.useFakeTranslations({
      edit_something: {
        tabs: {
          general: 'Something'
        }
      },
      edit_section: {
        tabs: {
          general: 'Section'
        }
      }
    });

    it('is used for tab labels', () => {
      const Model = Backbone.Model.extend({
        mixins: [configurationContainer(), failureTracking]
      });
      const View = EditConfigurationView.extend({
        translationKeyPrefix: 'edit_something',

        configure(configurationEditor) {
          configurationEditor.tab('general', function() {
            this.input('title', TextInputView);
          });
        }
      });

      const view = new View({model: new Model()}).render();
      const configurationEditor = ConfigurationEditor.find(view);

      expect(configurationEditor.tabLabels()).toContain('Something');
    });

    it('can be function', () => {
      const Model = Backbone.Model.extend({
        mixins: [configurationContainer(), failureTracking]
      });
      const View = EditConfigurationView.extend({
        translationKeyPrefix() {
          return `edit_${this.model.get('typeName')}`;
        },

        configure(configurationEditor) {
          configurationEditor.tab('general', function() {
            this.input('title', TextInputView);
          });
        }
      });

      const view = new View({model: new Model({typeName: 'section'})}).render();
      const configurationEditor = ConfigurationEditor.find(view);

      expect(configurationEditor.tabLabels()).toContain('Section');
    });
  });
});