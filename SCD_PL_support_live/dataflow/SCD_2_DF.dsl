source(output(
		surrkey as integer,
		id as integer,
		name as string,
		gender as string,
		country as string,
		IsActive as integer
	),
	allowSchemaDrift: true,
	validateSchema: false,
	isolationLevel: 'READ_UNCOMMITTED',
	format: 'table') ~> SOURCE1
source(output(
		id as integer,
		name as string,
		gender as string,
		country as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	ignoreNoFilesFound: false) ~> SOURCE
SOURCE derive(IsActive = 1) ~> derivedColumn
SOURCE1 select(mapColumn(
		TARGET_surrkey = surrkey,
		TARGET_id = id,
		TARGET_name = name,
		TARGET_gender = gender,
		TARGET_country = country,
		TARGET_IsActive = IsActive
	),
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true) ~> select
SOURCE, select lookup(id == TARGET_id,
	multiple: false,
	pickup: 'any',
	broadcast: 'auto')~> lookup
lookup filter(!isNull(TARGET_id)) ~> FILTER
FILTER select(mapColumn(
		TARGET_surrkey,
		TARGET_id,
		TARGET_name,
		TARGET_gender,
		TARGET_country,
		TARGET_IsActive
	),
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true) ~> select1
select1 derive(TARGET_IsActive = 0) ~> derivedColumn1
derivedColumn1 alterRow(updateIf(1 == 1)) ~> alterRow1
derivedColumn sink(allowSchemaDrift: true,
	validateSchema: false,
	input(
		surrkey as integer,
		id as integer,
		name as string,
		gender as string,
		country as string,
		IsActive as integer
	),
	deletable:false,
	insertable:true,
	updateable:false,
	upsertable:false,
	format: 'table',
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	saveOrder: 2,
	errorHandlingOption: 'stopOnFirstError',
	mapColumn(
		id,
		name,
		gender,
		country,
		IsActive
	)) ~> TARGET
alterRow1 sink(allowSchemaDrift: true,
	validateSchema: false,
	input(
		surrkey as integer,
		id as integer,
		name as string,
		gender as string,
		country as string,
		IsActive as integer
	),
	deletable:false,
	insertable:false,
	updateable:true,
	upsertable:false,
	keys:['surrkey'],
	format: 'table',
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	saveOrder: 1,
	errorHandlingOption: 'stopOnFirstError',
	mapColumn(
		surrkey = TARGET_surrkey,
		id = TARGET_id,
		name = TARGET_name,
		gender = TARGET_gender,
		country = TARGET_country,
		IsActive = TARGET_IsActive
	)) ~> TARGET1