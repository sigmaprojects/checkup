<cfoutput>

<div class="panel panel-default">
	<div class="panel-heading">Duties</div>
	<div class="panel-body">
		<p>List of all the duties <a href="#event.buildLink('checkup:duty.edit')#" class="btn btn-default pull-right">Create New</a></p>
	</div>

	<table class="table">
		<thead>
			<tr>
				<th>Origin</th>
				<th>ID</th>
				<th>URL</th>
			</tr>
		</thead>
		<tbody>
			<cfloop array="#rc.duties#" index="Duty">
				<tr>
					<td>
						<cfif Duty.hasOrigin()>
							#Duty.getOrigin().getLabel()# (#Duty.getOrigin().getId()#)
						</cfif>
					</td>
					<td>#Duty.getId()#</td>
					<td>#Duty.getDutyUrl()#</td>
				</tr>
			</cfloop>
		</tbody>
	</table>

</div>

</cfoutput>