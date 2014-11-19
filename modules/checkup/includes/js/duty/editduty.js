function editduty(){
	this.Init();
};
editduty.prototype.Init = function(){
	var objSelf = this;
	
	objSelf.Context = $('#edit-duty');
	
	objSelf.Context.find('button#buildDutyExpectation').on('click',
		function( objEvent ) {
			objSelf.buildDutyExpectation( objSelf.Context.find('form') );
			//objEvent.preventDefault();
			//return( false );
		}
	);

	objSelf.Context.on('click','button.removeDutyExpectation',
		function( objEvent ) {
			$(this).parents('.form-group').remove();
			objEvent.preventDefault();
			return( false );
		}
	);
	

	
};


editduty.prototype.buildDutyExpectation = function( jForm ) {
	var objSelf = this;
	var container = jForm.find('div#expectation-builder');
	console.log(container.html());
	var newContainer = container.clone();
	newContainer.removeAttr('id');
	newContainer.find('select#expectation_field').attr('name','field').removeAttr('id').prop('selectedIndex',container.find('select#expectation_field option:selected').index());
	newContainer.find('select#expectation_operator').attr('name','operator').removeAttr('id').prop('selectedIndex',container.find('select#expectation_operator option:selected').index());
	newContainer.find('input#expectation_value').attr('name','value').removeAttr('id');
	newContainer.find('button#buildDutyExpectation').removeAttr('id').addClass('removeDutyExpectation').text('Remove');
	newContainer.append('<input type="hidden" name="dutyexpectation_id" value="" />');
	newContainer.insertAfter(container);
	// reset the form elements
	container.find('select#expectation_field').prop('selectedIndex',1);
	container.find('select#expectation_operator').prop('selectedIndex',1);
	container.find('input#expectation_value').val('');
	return;
};


$(function() { new editduty(); });
