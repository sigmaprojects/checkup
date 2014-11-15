<cfoutput>

<form class="form-horizontal">

	<fieldset>
		<legend>Edit Duty</legend>


		<div class="form-group">
			<label class="col-md-4 control-label" for="dutyurl">URL</label>  
			<div class="col-md-4">
				<input id="dutyurl" name="dutyurl" type="text" placeholder="http://www.example.com" class="form-control input-md" required="">
				<span class="help-block">The Full URL the caller will attempt to contact</span>  
			</div>
		</div>


		<div class="form-group">
			<label class="col-md-4 control-label" for="buttondropdown">Expectation</label>

				<div class="col-md-2">
					<select id="selectbasic" class="form-control">
						<option disabled="">Field</option>
						<option value="body">HTML Body</option>
						<option value="statucode">HTTP Status Code</option>
					</select>
				</div>
				<div class="col-md-2">	
					<select id="selectbasic" class="form-control">
						<option disabled="">Operator</option>
						<cfloop array="#rc.Expectations#" index="Expectation">
							<option value="#Expectation.getId()#">#Expectation.getLabel()#</option>
						</cfloop>
					</select>
				</div>
				<div class="col-md-3">
					<input name="buttondropdown" class="form-control" placeholder="Value" type="text" required="">
				</div>
				<div class="col-sm-1">
					<button class="btn btn-primary">Add</a>
				</div>
			</div>
		</div>

	</fieldset>
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