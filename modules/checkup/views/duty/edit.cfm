<cfoutput>
<script type="text/javascript" src="#event.getModuleRoot()#/includes/js/duty/editduty.js"></script>

<div id="edit-duty">

<form class="form-horizontal" method="post" action="#event.buildLink('checkup:duty.save')#">
	<input type="hidden" name="duty_id" value="#rc.Duty.getId()#" />
	<fieldset>
		<legend>Edit Duty</legend>

		<div class="form-group">
			<label class="col-md-4 control-label" for="dutyurl">URL</label>  
			<div class="col-md-4">
				<input id="dutyurl" name="dutyurl" type="text" placeholder="http://www.example.com" class="form-control input-md" required="" value="#rc.Duty.getDutyUrl()#">
				<span class="help-block">The Full URL the caller will attempt to contact</span>  
			</div>
		</div>

		<div class="form-group" id="expectation-builder">
			<label class="col-md-4 control-label" for="buttondropdown">Expectation</label>

			<div class="col-md-2">
				<select id="expectation_field" class="form-control">
					<option disabled="">Field</option>
					<option value="body">HTML Body</option>
					<option value="statuscode">HTTP Status Code</option>
				</select>
			</div>
			<div class="col-md-2">	
				<select id="expectation_operator" class="form-control">
					<option disabled="">Operator</option>
					<cfloop array="#rc.Expectations#" index="Expectation">
						<option value="#Expectation.getId()#">#Expectation.getLabel()#</option>
					</cfloop>
				</select>
			</div>
			<div class="col-md-3">
				<input id="expectation_value" class="form-control" placeholder="Value" type="text">
			</div>
			<div class="col-sm-1">
				<button type="button" class="btn btn-default" id="buildDutyExpectation">Add</a>
			</div>
		</div>
		
		<cfif rc.Duty.hasDutyExpectation()>
		<cfloop array="#rc.Duty.getDutyExpectations()#" index="DutyExpectation">
			<div class="form-group">
				<input type="hidden" name="dutyexpectation_id" value="#DutyExpectation.getId()#" />
				<label class="col-md-4 control-label" for="buttondropdown">Expectation</label>
				
				<div class="col-md-2">
					<select name="field" class="form-control">
						<option disabled="">Field</option>
						<option value="body" <cfif DutyExpectation.getField() eq "body">selected="selected"</cfif>>HTML Body</option>
						<option value="statuscode" <cfif DutyExpectation.getField() eq "statuscode">selected="selected"</cfif>>HTTP Status Code</option>
					</select>
				</div>
				<div class="col-md-2">	
					<select name="operator" class="form-control">
						<option disabled="">Operator</option>
						<cfloop array="#rc.Expectations#" index="Expectation">
							<option value="#Expectation.getId()#" <cfif DutyExpectation.getExpectation().getid() eq Expectation.getId()>selected="selected"</cfif>>#Expectation.getLabel()#</option>
						</cfloop>
					</select>
				</div>
				<div class="col-md-3">
					<input name="value" class="form-control" placeholder="Value" type="text" required="" value="#DutyExpectation.getValue()#">
				</div>
				<div class="col-sm-1">
					<button type="button" class="btn btn-default removeDutyExpectation">Remove</a>
				</div>
			</div>
		</cfloop>
		</cfif>


		<div class="form-group">
			<label class="col-md-5 control-label">&nbsp;</label>  
			<div class="col-md-4">
				<button type="submit" class="btn btn-primary">Save</button>
			</div>
		</div>
	</fieldset>

</div>


<!--
</form>
    <form class="form-horizontal" role="form">
      <div class="form-group">
        <label for="inputCity" class="col-lg-2 control-label">Ineed</label>
        <div class="col-lg-3">
          <select class="form-control">
                <option>Bakery</option>
              </select>
        </div>
        <label for="inputType" class="col-lg-1 control-label">In</label>
        <div class="col-lg-3">
          <input type="text" class="form-control" id="inputCity" placeholder="City"> 
        </div>
        <button type="submit" class="btn btn-success">Go</button>
      </div>
    </form>
  </div>
-->
</cfoutput>