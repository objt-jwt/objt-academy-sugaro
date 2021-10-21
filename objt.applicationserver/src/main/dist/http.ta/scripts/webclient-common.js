var OPERATION_ACTION = "action";
var OPERATION_RENDER_ACTIONUI = "actionui";

var STATUS_OK = 200;
var STATUS_CONFIRMATION = 202;

var touchStartedComponent = undefined;

jQuery(document).ready(function()
{
  //console.log("ready");

  /** When an action is clicked, we send the selectedRefs + tableRef + actionId to the server for processing **/
  $(document).on('click', '.webaction', function(event)
  {
    return triggerAction(jQuery(this), null, (jQuery(this).attr('fetchUIOnClick') == 'true' ? OPERATION_RENDER_ACTIONUI : OPERATION_ACTION), false);
  });

  /** When a row action is clicked, we send the selectedRef + tableRef + actionId to the server for processing **/
  $(document).on('click', '.webrowaction', function(event)
  {
    return triggerAction(jQuery(this), null, (jQuery(this).attr('fetchUIOnClick') == 'true' ? OPERATION_RENDER_ACTIONUI : OPERATION_ACTION), false);
  });

  /** Select/Deselect a row in a selectable table to be able to detect selection & change layout of selected rows **/
  var ua = navigator.userAgent;
  if (ua.match(/iPad/i) || ua.match(/iPhone/i))
  {
    $(document).on('touchstart', '.selectableTable tbody tr',
      function(event)
      {
         touchStartedComponent = event.target;
      }
    );
    $(document).on('touchmove', '.selectableTable tbody tr',
      function(event)
      {
         touchStartedComponent = undefined;
      }
    );
    $(document).on('touchend', '.selectableTable tbody tr',
      function(event)
      {
        if (event.target == touchStartedComponent)
        {
          childListRowSelect(event, jQuery(this));
        }
        touchStartedComponent = undefined;
      }
    );
  }
  else
  {
    $(document).on('click', '.selectableTable tbody tr',
      function () { return function(event) { childListRowSelect(event, jQuery(this)); } }()
    );
  }
});

// Destroy the popup-dialog when it is closed to prevent double instances.
$(document).on('dialogclose', '#popup-dialog', function(event)
 {
   jQuery(this).dialog('destroy');
 });

 
/** Row selection event **/
childListRowSelect = function(event, pComponent)
{
  //console.log("childListRowSelect");
  if (!jQuery(event.target).is('td')) return true;

  if (pComponent.hasClass('norecords')) return;

  var parentTableList = pComponent.parents("table");
  var parentTable = null;
  if (parentTableList.length > 0)
  {
    parentTable = jQuery(parentTableList[0]);
  }

  if (parentTable == null) return;

  if (parentTable.attr('selectType') == 'none') return;
  if (pComponent.hasClass('selected'))
  {
    pComponent.removeClass('selected');
    //console.log("deselect");
  }
  else
  {
    if (parentTable.attr('selectType') == 'single')
    {
      parentTable.find('tr').removeClass('selected');
    }
    pComponent.addClass('selected');
    //console.log("select");
  }

  event.preventDefault();
  event.stopPropagation();

  return false;
}

/**
 * show/load the content page
 */
showPage = function(pURL, pAction, pBaseRef)
{
  $.ajax
  ({
      url: pURL,
      data: {'action': pAction,
             'baseref': pBaseRef},
      success: function(data)
      {
        // show result in content div
        $('#content').html(data);
      },
      type: 'get',
      cache: false
  });
}

/**
 * reload page using form data in new window
 **/
showPageInWindow = function(pForm)
{
	var data = $(pForm).serialize();
  var url = ajaxurl + '?window=true&' + data;
	
  var w = window.open(url,'Objective','resizable=1,scrollbars=1,location=0,toolbar=0,menubar=0');
}


/** update the data content by using all form info **/
updateData = function(pForm, pDataContent)
{
	var data = $(pForm).serializeArray();
  data.push({name:"updateMode", value: true});
  $.ajax
  ({
      url: ajaxurl,
      data: data,
      success: function(data)
      {
        // show result in data content div
        $(pDataContent).html(data);
      },
      type: 'post'
  });
}
 

/**
  * Handle the triggering (click) of an action
  *
  *  pAction: jQuery element of the action triggered
  *  pData: data containing data to send to the server
  *  pOperation: the action to perform: action of dialog
  *  pConfirmation: is action already confirmed or not
  **/
triggerAction = function(pAction, pData, pOperation, pConfirmation)
{
  //console.log("triggerAction");

  var actionId = pAction.attr('id');

  var panelContainer = getPanelContainer(pAction);
  if (panelContainer == null) return;
	
  var panelId = panelContainer.attr('id');

	var tableRef = "";
  var selectedRefs = "";

  if (pAction.hasClass('webrowaction'))
  {
    // this is a row based action

 	  // Find row where this action is in
	  var tableRow = jQuery(pAction.parents('tr')[0]);
    if (tableRow == null) return;

    selectedRefs = tableRow.attr('ref');

	  var childListTable = getChildListTable(panelContainer);
    if (childListTable != null)
	  {
		  tableRef = childListTable.attr('ref');
    }
  }
  else
  {
    // this is a toolbar action

    // get all selected row refs
	  var selectableTable = getSelectableTable(panelContainer);
    if (selectableTable != null)
	  {
		  tableRef = selectableTable.attr('ref');

  	  // Build list of selected row references
      var allSelected = jQuery(selectableTable).find('.selected');
		  for (var i = 0; i < allSelected.size(); i++)
		  {
			  if (selectedRefs != "") selectedRefs += "||";
			  selectedRefs += jQuery(allSelected[i]).attr('ref');
		  }
    }
  }

  var data = {};
  data.action = panelId + "." + actionId;
  data.actionid = actionId;
  data.panelid = panelId;
  data.tableref = tableRef;
  data.selectedrefs = selectedRefs;
  data.confirmation = pConfirmation;

  if (pOperation == OPERATION_ACTION)
  {
    jQuery.ajax(
    {
      type: "POST",
      url: ajaxurl,
      data: data,
      success: function(pActionParam, pOriginalData, pOriginalConfirmation)
      {
        return function(result, textStatus, jqXHR)
        {
          if (jqXHR.status == STATUS_CONFIRMATION)
          {
            // confirmation required
            var res = confirm((result != null) && (result != undefined) ? result.replace(/\\/g, "") : result);
            if (res != true)
            {
              return;
            }

            triggerAction(pActionParam, pOriginalData, OPERATION_ACTION, true);
            return;
          }

          if ((jqXHR.status == STATUS_OK) && (result != '') && (result != undefined) && (result != null))
          {
            eval(result);
          }
        }
      }(pAction, data, pConfirmation),
      dataType: 'text'
    });
  }
  else if (pOperation == OPERATION_RENDER_ACTIONUI)
  {
		// Show dialog
    jQuery.ajax(
    {
      type: "POST",
      url: ajaxurl,
      data: data,
      success: function(pActionParam)
      {
        return function(result, textStatus, jqXHR)
        {
          if ((result != null) && (result != ""))
          {
            panelContainer.find('div.actionUIContainer').html(result);
          }
        }
      }(pAction),
      dataType: 'text'
    });
  }
  return false;
}


// tablesorter tweak standard bootstrap theme to 'disable' table-striped
$.tablesorter.themes.bootstrap = {
    table        : 'table table-bordered',
    caption      : 'caption',
    header       : 'bootstrap-header',
    sortNone     : '',
    sortAsc      : '',
    sortDesc     : '',
    active       : '', 
    hover        : '', 
    // icon class names
    icons        : '', 
    iconSortNone : 'bootstrap-icon-unsorted', 
    iconSortAsc  : 'glyphicon glyphicon-chevron-up', 
    iconSortDesc : 'glyphicon glyphicon-chevron-down', 
    filterRow    : '', 
    footerRow    : '',
    footerCells  : '',
    even         : '', 
    odd          : ''  
  }; 


/**
 * Initialize the table with the tablesorter plugin
 */
loadTableSorter = function(pTableId)
{
  //console.log("loadTableSorder " + pTableId);
  jQuery("table[id='" + pTableId + "']").tablesorter({
    theme : "bootstrap",
    headerTemplate : '{content} {icon}',
    widgets : [ "uitheme" ]
  })
}

/**
 * (Re)Set the accordion
 */
showAccordeon = function(pId)
{
}


/** Utility Calls **/
getPanelContainer = function(jQueryElement)
{
  if (jQueryElement.hasClass('panelContainer')) return jQueryElement;
  return jQuery(jQueryElement.parents('div.panelContainer')[0]);
}

getSelectableTable = function(jQueryElement)
{
  if (jQueryElement.hasClass('selectableTable')) return jQueryElement;
  return jQuery(jQueryElement.find('table.selectableTable')[0]);
}

getChildListTable = function(jQueryElement)
{
  if (jQueryElement.hasClass('childListTable')) return jQueryElement;
  return jQuery(jQueryElement.find('table.childListTable')[0]);
}
