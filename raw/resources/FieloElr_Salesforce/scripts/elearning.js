(function() {
  'use strict';

  /**
   * @description Controlador para la Landing de Content
   * Implementa los patrones de diseño definidos por MDL en
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Hugo Gómez Mac Gregor <hugo.gomez@fielo.com>
   * @param {HTMLElement} element - Elemento que será mejorado.
   * @constructor
   */
  var FieloELearning = function FieloELearning(element) {
    this.element_ = element;

    // Initialize instance.
    this.init();
  };
  window.FieloELearning = FieloELearning;

 /**
   * Guarda strings para nombres de clases definidas por este componente
   * que son usadas por JavaScript.
   * Esto nos permite cambiarlos solo en un lugar
   * @enum {string}
   * @private
   */
  FieloELearning.prototype.CssClasses_ = {
    // Courses Container
    COURSES_CONTAINER: 'fielosf-courses-container',
    // New Course Button
    CREATE_COURSE: 'fielosf-create-course',
    // Tabs
    TABS: 'slds-tabs--default',
    // Program Selector
    PROGRAM_SELECTOR: 'fielosf-program-selector',
    // Filter
    VIEW_SELECTOR: 'fielosf-view-selector',
    // Title
    TITLE: 'slds-page-header__title',
    // Hide
    HIDE: 'slds-hide',
    // LANDING PAGE
    LANDING_PAGE: 'fielosf-elearning-landing',
    // COURSE VIEW PAGE
    COURSE_VIEW_PAGE: 'fielosf-course-view',
    // MODULE VIEW PAGE
    MODULE_VIEW_PAGE: 'fielosf-module-view',
    // RECENT RECORDS
    RECENT_RECORDS: 'fielosf-recent-records',
    // RECENT REORDER
    RECENT_REORDER: 'fielosf-recent-reorder',
    // RELATED MODEL
    RELATED_MODEL: 'fielosf-related-records__model'
  };

    /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloELearning.prototype.Constant_ = {
    COURSES: 'courses-panel',
    LANDING_SEGMENT_CONTROLLER: 'FieloELR.CourseLandingController.getSegments', // eslint-disable-line max-len
    VIEW_SEGMENT_CONTROLLER: 'FieloELR.CourseViewController.getSegments'
  };

  /**
  * Setea valoes por defecto
  */
  FieloELearning.prototype.setDefaults_ = function() {
    // tabs
    this.title_ =
      this.element_.getElementsByClassName(this.CssClasses_.TITLE)[0];

    // New Button
    this.createcourse_ = this.element_
      .getElementsByClassName(this.CssClasses_.CREATE_COURSE)[0];

    // Object to get the data
    // Courses
    this.viewSelector_ = this.element_
      .getElementsByClassName(this.CssClasses_.VIEW_SELECTOR)[0] === undefined ?
        null :
        this.element_.getElementsByClassName(
          this.CssClasses_.VIEW_SELECTOR)[0].FieloFilter;
    if (this.viewSelector_ !== null) {
      this.viewSelector_.callback = this.updateViewTitle.bind(this);
    }

    this.memberId_ = null;
    this.updateViewTitle();
  };

  FieloELearning.prototype.updateViewTitle = function() {
    if (this.viewSelector_ !== undefined && this.viewSelector_ !== null) {
      if (this.viewSelector_.itemActive_ !== undefined &&
          this.viewSelector_.itemActive_ !== null) {
        this.title_.textContent =
          String(this.viewSelector_.itemActive_.textContent).trim() +
            ' Courses';
      }
    }
  };

  FieloELearning.prototype.renderSegments_ = function(result) {
    fielo.util.spinner.FieloSpinner.hide();
    var segments = this.activeForm_.elements_.FieloELR__Segment__c;
    if (segments) {
      var newSegments = [];
      result.forEach(function(segment) {
        newSegments.push({id: segment.Id, label: segment.Name});
      });
      segments.setAttribute('data-options', JSON.stringify(newSegments));
      segments.FieloFormElement.configMultiselect_();
    }
  };

  FieloELearning.prototype.getSegments = function() {
    var segmentController =
      document.getElementsByClassName(
        this.CssClasses_.LANDING_PAGE)[0] === undefined ?
          this.Constant_.VIEW_SEGMENT_CONTROLLER :
            this.Constant_.LANDING_SEGMENT_CONTROLLER;

    fielo.util.spinner.FieloSpinner.show();
    try {
      Visualforce.remoting.Manager.invokeAction(
        segmentController,
        this.memberId_,
        this.renderSegments_.bind(this),
        {
          escape: false
        }
      );
    } catch (e) {
      console.warn(e);
    }
  };

  FieloELearning.prototype.disableProgramChange_ = function() {
    if (document.getElementsByClassName(
        this.CssClasses_.COURSE_VIEW_PAGE)[0] !== undefined) {
      $('[data-field-name="FieloELR__Program__c"]')
      .addClass('disabled');
    }
  };

  FieloELearning.prototype.disableCourseChange_ = function() {
    if (document.getElementsByClassName(
        this.CssClasses_.COURSE_VIEW_PAGE)[0] !== undefined ||
        document.getElementsByClassName(
        this.CssClasses_.MODULE_VIEW_PAGE)[0] !== undefined) {
      $('[data-field-name="FieloELR__Course__c"]')
      .addClass('disabled');
    }
  };

  FieloELearning.prototype.disableModuleChange_ = function() {
    if (document.getElementsByClassName(
        this.CssClasses_.MODULE_VIEW_PAGE)[0] !== undefined) {
      $('[data-field-name="FieloELR__Module__c"]')
      .addClass('disabled');
    }
  };

  FieloELearning.prototype.hideRelatedColumn = function(element, fieldName) {
    var items = $(element)
      .find('.' + this.CssClasses_.RELATED_MODEL);
    var currentField = null;

    [].forEach.call(items, function(item) {
      currentField = $(item)
        .find('[data-field="' + fieldName + '"]')[0];
      if (currentField) {
        $(currentField).toggle(false);
        $(currentField).parent().toggle(false);
      }
    }, this);

    if (currentField) {
      var index = $(currentField).parent().index();
      var column = $(currentField).closest('table')
        .find('thead')
          .find('tr')[0].cells[index];
      $(column).toggle(false);
    }
  };

  FieloELearning.prototype.reorderRenderRecords_ = function(records) {
    var recent =
      $('.' + this.CssClasses_.RECENT_RECORDS)[0]
        .FieloRecentRecords;
    recent.renderRecords_(records);
    var recentReorder =
      $('.' + this.CssClasses_.RECENT_REORDER)[0]
        .FieloRecentReorder;
    recentReorder.removeGrips();
    recentReorder.addGrips();
  };

  FieloELearning.prototype.decodeEntities = function(encodedString) {
    var textArea = document.createElement('textarea');
    textArea.innerHTML = encodedString;
    return textArea.value;
  };

  FieloELearning.prototype.fixJSON = function() {
    var JSONField =
      $('#formModel').find('[data-field-name="FieloPLT__JSON__c"]')[0];
    if (JSONField) {
      JSONField.FieloFormElement.set('value',
        this.decodeEntities(JSONField.FieloFormElement.get('value'))
      );
    }
  };

  FieloELearning.prototype.programChangeProxy_ = function(value) {
    var _this = document.getElementsByClassName(
      'fielosf-elearning')[0].FieloELearning;
    _this.activeForm_ = $(this.element_).closest('.slds-form')[0].FieloForm;
    if (value && value.id !== _this.memberId_) {
      _this.memberId_ = value.id;
      _this.getSegments();
    }
  };
  window.RefreshSegments = // eslint-disable-line camelcase
    FieloELearning.prototype.programChangeProxy_; // eslint-disable-line no-undef
   /**
   * Inicializa el elemento
   */
  FieloELearning.prototype.init = function() {
    if (this.element_) {
      this.setDefaults_();

      $(this.element_).on('shown.aljs.modal', function() {
        var _this = document.getElementsByClassName(
          'fielosf-elearning')[0];
        _this.FieloELearning.disableProgramChange_();
      });

      $('#FieloELR__Module__cFormNew').on('shown.aljs.modal', function() {
        var _this = document.getElementsByClassName(
          'fielosf-elearning')[0];
        _this.FieloELearning.disableCourseChange_();
      });

      $('#FieloELR__Module__cForm').on('shown.aljs.modal', function() {
        var _this = document.getElementsByClassName(
          'fielosf-elearning')[0];
        _this.FieloELearning.disableCourseChange_();
      });

      $('#FieloELR__CourseDependency__cFormNew')
        .on('shown.aljs.modal', function() {
          var _this = document.getElementsByClassName(
            'fielosf-elearning')[0];
          _this.FieloELearning.disableCourseChange_();
        });

      $('#FieloELR__CourseDependency__cForm')
        .on('shown.aljs.modal', function() {
          var _this = document.getElementsByClassName(
            'fielosf-elearning')[0];
          _this.FieloELearning.disableCourseChange_();
        });

      $('#FieloELR__Question__cForm').on('shown.aljs.modal', function() {
        var _this = document.getElementsByClassName(
          'fielosf-elearning')[0];
        _this.FieloELearning.disableModuleChange_();
      });

      $('#FieloELR__Question__cFormNew').on('shown.aljs.modal', function() {
        var _this = document.getElementsByClassName(
          'fielosf-elearning')[0];
        _this.FieloELearning.disableModuleChange_();
      });

      $('#FieloELR__ModuleDependency__cForm').on(
          'shown.aljs.modal', function() {
            var _this = document.getElementsByClassName(
              'fielosf-elearning')[0];
            _this.FieloELearning.disableModuleChange_();
          });

      $('#FieloELR__ModuleDependency__cFormNew').on(
        'shown.aljs.modal', function() {
          var _this = document.getElementsByClassName(
          'fielosf-elearning')[0];
          _this.FieloELearning.disableModuleChange_();
        });

      $('#FieloELR__Question__cFormWizard-multiplechoice').on(
        'shown.aljs.modal', function() {
          var _this = document.getElementsByClassName(
          'fielosf-elearning')[0];
          _this.FieloELearning.disableModuleChange_();
        });

      $('#FieloELR__Question__cForm-multiplechoice').on(
        'shown.aljs.modal', function() {
          var _this = document.getElementsByClassName(
          'fielosf-elearning')[0];
          _this.FieloELearning.disableModuleChange_();
        });

      $('#FieloELR__Module__cFormReorder').on(
        'shown.aljs.modal', function(event) {
          var _this = document.getElementsByClassName(
            'fielosf-elearning')[0];
          var recent =
            $(event.target)
              .find('.' + _this.FieloELearning.CssClasses_.RECENT_RECORDS)[0];
          var paginator =
            recent.FieloRecentRecords.getPaginator();
          if (paginator) {
            if (paginator.FieloPaginator) {
              paginator.FieloPaginator.setPage();
              paginator.FieloPaginator.getRecords();
              paginator.FieloPaginator.callback =
                _this.FieloELearning
                  .reorderRenderRecords_.bind(_this.FieloELearning);
            }
          }
        });
      var courseDependencyRelated =
        $('#FieloELR__CourseDependency__cRelatedList')[0];
      if (courseDependencyRelated) {
        this.hideRelatedColumn(courseDependencyRelated, 'Name');
      }
      var moduleDependencyRelated =
        $('#FieloELR__ModuleDependency__cRelatedList')[0];
      if (moduleDependencyRelated) {
        this.hideRelatedColumn(moduleDependencyRelated, 'Name');
      }

      var saveAsModelForm =
        $('#formModel')[0];
      if (saveAsModelForm) {
        saveAsModelForm.FieloForm.endRetrieve = this.fixJSON.bind(this);
      }
    }
  };

  // El componente se registra por si solo.
  // Asume que el componentHandler esta habilitado en el scope global
  fielo.helper.register({
    constructor: FieloELearning,
    classAsString: 'FieloELearning',
    cssClass: 'fielosf-elearning',
    widget: true
  });
})();

