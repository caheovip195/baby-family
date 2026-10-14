-- Synthetic fixtures only. Run in the fresh disposable candidate DB after assertions.sql.
BEGIN;
CREATE TEMP TABLE design_check_results (name text PRIMARY KEY) ON COMMIT DROP;
CREATE FUNCTION pg_temp.require_true(value boolean, label text) RETURNS void LANGUAGE plpgsql AS $$
BEGIN
  IF value IS DISTINCT FROM true THEN RAISE EXCEPTION 'Assertion failed: %', label; END IF;
  INSERT INTO design_check_results VALUES (label);
END $$;
CREATE FUNCTION pg_temp.reject(command text, expected_state text, label text) RETURNS void LANGUAGE plpgsql AS $$
DECLARE actual_state text;
BEGIN
  BEGIN
    EXECUTE command;
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS actual_state = RETURNED_SQLSTATE;
    IF actual_state <> expected_state THEN
      RAISE EXCEPTION 'Wrong rejection for %: expected %, got %',label,expected_state,actual_state;
    END IF;
    INSERT INTO design_check_results VALUES (label);
    RETURN;
  END;
  RAISE EXCEPTION 'Expected rejection did not occur: %', label;
END $$;

DO $test$
DECLARE
  u1 uuid := uuidv7(); u2 uuid := uuidv7(); outsider uuid := uuidv7();
  f1 uuid := uuidv7(); f2 uuid := uuidv7(); p1 uuid := uuidv7(); p2 uuid := uuidv7();
  couple uuid := uuidv7(); child1 uuid := uuidv7(); child2 uuid := uuidv7(); child_other uuid := uuidv7();
  preg uuid := uuidv7(); circle uuid := uuidv7(); mem uuid := uuidv7(); mission uuid := uuidv7();
  plan uuid := uuidv7(); pv uuid := uuidv7(); product uuid := uuidv7();
  lic1 uuid := uuidv7(); lic2 uuid := uuidv7(); intent uuid := uuidv7(); intent2 uuid := uuidv7();
  sub uuid := uuidv7(); sub2 uuid := uuidv7(); tx uuid := uuidv7(); trial uuid := uuidv7();
  run uuid := uuidv7(); journal uuid := uuidv7();
  source uuid := uuidv7(); heart bigint; audit_created timestamptz; audit_updated timestamptz;
  avatar uuid := uuidv7(); support_asset uuid := uuidv7(); ticket uuid := uuidv7();
  trial_policy uuid := uuidv7(); renewal_tx uuid := uuidv7();
BEGIN
  INSERT INTO app.users(id,display_name) VALUES(u1,'Design Parent A'),(u2,'Design Parent B'),(outsider,'Design Other');
  INSERT INTO app.user_assets(id,owner_user_id,purpose,storage_key,mime,declared_size)
    VALUES(avatar,u1,'AVATAR','design-avatar','image/jpeg',100),
          (support_asset,u1,'SUPPORT','design-support','image/png',100);
  UPDATE app.users SET avatar_asset_id=avatar WHERE id=u1;
  PERFORM pg_temp.require_true((SELECT avatar_asset_id=avatar FROM app.users WHERE id=u1),'Avatar can be set before a user has any family');
  PERFORM pg_temp.reject(format('UPDATE app.users SET avatar_asset_id=%L WHERE id=%L',avatar,u2),'23514','User cannot adopt another user avatar');
  PERFORM pg_temp.reject(format('UPDATE app.users SET avatar_asset_id=%L WHERE id=%L',support_asset,u1),'23514','Private support attachment cannot be exposed as avatar');
  INSERT INTO app.support_tickets(id,requester_user_id,category,message_enc) VALUES(ticket,u1,'GENERAL',decode('01','hex'));
  INSERT INTO app.support_ticket_attachments(ticket_id,owner_user_id,asset_id) VALUES(ticket,u1,support_asset);
  PERFORM pg_temp.require_true(true,'Support attachment works without family membership');
  INSERT INTO app.families(id,name,created_by) VALUES(f1,'Design family A',u1),(f2,'Design family B',outsider);
  INSERT INTO app.family_parents(id,family_id,user_id,slot,kind,call_name)
    VALUES(p1,f1,u1,'A','FATHER','Papa'),(p2,f1,u2,'B','FATHER','Papa');
  PERFORM pg_temp.require_true((SELECT count(*)=2 FROM app.family_parents WHERE family_id=f1),'A/B slots permit same parent kind');
  PERFORM pg_temp.reject(format('INSERT INTO app.family_parents(family_id,user_id,slot,kind,call_name) VALUES(%L,%L,''A'',''MOTHER'',''Mama'')',f1,outsider),'23505','Third active Parent cannot occupy used slot');
  PERFORM pg_temp.reject(format('INSERT INTO app.family_parents(family_id,user_id,slot,kind,call_name) VALUES(%L,%L,''A'',''FATHER'',''Papa'')',f2,u1),'23505','One user cannot be active Parent in two families');
  INSERT INTO app.couple_spaces(id,family_id,parent_a_user_id,parent_b_user_id,parent_a_membership_id,parent_b_membership_id)
    VALUES(couple,f1,u1,u2,p1,p2);
  INSERT INTO app.pregnancies(id,family_id,seq_no,nickname,created_by) VALUES(preg,f1,1,'Design pregnancy',u1);
  INSERT INTO app.children(id,family_id,name,birth_date,color_index,created_by)
    VALUES(child1,f1,'Design child A','2025-01-01',1,u1),(child2,f1,'Design child B','2025-02-01',2,u1),(child_other,f2,'Design other child','2025-03-01',3,outsider);
  PERFORM pg_temp.reject(format('INSERT INTO app.children(family_id,name,birth_date,color_index,created_by,pregnancy_id) VALUES(%L,''Test'',''2025-01-01'',1,%L,%L)',f1,u1,preg),'23514','Pregnancy child requires birth order despite SQL NULL logic');
  PERFORM pg_temp.reject(format('INSERT INTO app.children(family_id,name,birth_date,color_index,created_by) VALUES(%L,''   '',''2025-01-01'',1,%L)',f1,u1),'23514','Child requires a nonblank name or nickname');
  INSERT INTO app.circle_members(id,family_id,user_id,relation,display_name) VALUES(circle,f1,outsider,'OTHER','Design relative');
  INSERT INTO app.circle_grants(family_id,circle_member_id,child_id,permission,created_by) VALUES(f1,circle,child1,'VIEW',u1);
  PERFORM pg_temp.reject(format('INSERT INTO app.circle_grants(family_id,circle_member_id,permission,created_by) VALUES(%L,%L,''VIEW'',%L)',f1,circle,u1),'23514','Circle grant requires exactly one subject');
  PERFORM pg_temp.reject(format('INSERT INTO app.circle_grants(family_id,circle_member_id,child_id,pregnancy_id,permission,created_by) VALUES(%L,%L,%L,%L,''VIEW'',%L)',f1,circle,child2,preg,u1),'23514','Circle grant cannot target child and pregnancy together');
  PERFORM pg_temp.reject(format('INSERT INTO app.circle_grants(family_id,circle_member_id,child_id,permission,created_by) VALUES(%L,%L,%L,''VIEW'',%L)',f1,circle,child_other,u1),'23503','Circle grant rejects child from another family');
  INSERT INTO app.memories(id,family_id,author_user_id,author_role,body,occurred_at,occurred_local_date,visibility,status)
    VALUES(mem,f1,u1,'PARENT','Synthetic design fixture',now(),current_date,'PARENTS','PUBLISHED');
  INSERT INTO app.memory_children(memory_id,child_id,family_id,age_month) VALUES(mem,child1,f1,1);
  PERFORM pg_temp.reject(format('INSERT INTO app.memory_children(memory_id,child_id,family_id,age_month) VALUES(%L,%L,%L,1)',mem,child_other,f1),'23503','Memory child link rejects another family');
  PERFORM pg_temp.reject(format('UPDATE app.memories SET status=''TRASHED'' WHERE id=%L',mem),'23514','Trash status requires deleted timestamp and retention metadata');
  UPDATE app.memories SET status='TRASHED',deleted_at=statement_timestamp(),trashed_at=statement_timestamp(),purge_after=now()+interval '30 days' WHERE id=mem;
  PERFORM pg_temp.require_true((SELECT count(*)=0 FROM app.memories WHERE id=mem AND deleted_at IS NULL),'Soft-deleted memory is excluded by active predicate');
  UPDATE app.memories SET status='PUBLISHED',deleted_at=NULL,trashed_at=NULL,purge_after=NULL WHERE id=mem;
  PERFORM pg_temp.require_true((SELECT count(*)=1 FROM app.memories WHERE id=mem AND deleted_at IS NULL),'Memory can restore with consistent lifecycle');

  INSERT INTO app.missions(id,family_id,board_date,owner_kind,owner_user_id,source,title,category,target_scope,hearts,created_by)
    VALUES(mission,f1,current_date,'PARENT',u1,'CUSTOM','Design mission','CUSTOM','CHILD',2,u1);
  INSERT INTO app.mission_children(mission_id,child_id,family_id) VALUES(mission,child1,f1);
  SET CONSTRAINTS ALL IMMEDIATE;
  PERFORM pg_temp.require_true(true,'Deferred CHILD mission validates after its link is inserted');
  PERFORM pg_temp.reject(format('DELETE FROM app.mission_children WHERE mission_id=%L',mission),'23514','Deleting final CHILD mission subject is rejected');
  PERFORM pg_temp.reject(format('INSERT INTO app.mission_children(mission_id,child_id,family_id) VALUES(%L,%L,%L)',mission,child2,f1),'23514','CHILD mission cannot have two active children');
  PERFORM pg_temp.reject(format('INSERT INTO app.missions(family_id,board_date,owner_kind,owner_user_id,source,title,category,target_scope,hearts) VALUES(%L,current_date,''PARENT'',%L,''CUSTOM'',''Invalid'',''CUSTOM'',''FAMILY'',2)',f1,u1),'23514','Manual mission cannot bypass author rule with NULL created_by');
  INSERT INTO app.heart_ledger(family_id,user_id,source_type,source_id,reason,amount,local_date)
    VALUES(f1,u1,'MEMORY',source,'MEMORY_CREATED',2,current_date) RETURNING id INTO heart;
  PERFORM pg_temp.reject(format('INSERT INTO app.heart_ledger(family_id,user_id,source_type,source_id,reason,amount,local_date) VALUES(%L,%L,''MEMORY'',%L,''MEMORY_CREATED'',2,current_date)',f1,u1,source),'23505','Hearts business source cannot be credited twice');
  PERFORM pg_temp.reject(format('INSERT INTO app.heart_ledger(family_id,user_id,source_type,source_id,reason,amount,reversal_of,local_date) VALUES(%L,%L,''MEMORY'',%L,''REVERSAL'',-1,%s,current_date)',f1,u1,source,heart),'23514','Hearts reversal must negate original amount');
  INSERT INTO app.heart_ledger(family_id,user_id,source_type,source_id,reason,amount,reversal_of,local_date)
    VALUES(f1,u1,'MEMORY',source,'REVERSAL',-2,heart,current_date);
  PERFORM pg_temp.require_true((SELECT sum(amount)=0 FROM app.heart_ledger WHERE family_id=f1),'Hearts undo uses balanced reversal');
  PERFORM pg_temp.reject(format('UPDATE app.heart_ledger SET amount=3 WHERE id=%s',heart),'23514','Hearts ledger amount is immutable');

  INSERT INTO us.mood_checkins(couple_space_id,family_id,user_id,mood,expires_at) VALUES(couple,f1,u1,'GOOD',now()+interval '1 day');
  PERFORM pg_temp.reject(format('INSERT INTO us.mood_checkins(couple_space_id,family_id,user_id,mood,expires_at) VALUES(%L,%L,%L,''GOOD'',now()+interval ''1 day'')',couple,f1,outsider),'23514','Private couple row rejects outsider actor');
  PERFORM pg_temp.reject(format('UPDATE app.couple_spaces SET parent_b_user_id=%L WHERE id=%L',outsider,couple),'23514','Historical couple cannot be rebound to a new partner');
  INSERT INTO us.journal_entries(id,user_id,family_id,body_enc) VALUES(journal,u1,f1,decode('01','hex'));
  PERFORM pg_temp.reject(format('UPDATE us.journal_entries SET user_id=%L WHERE id=%L',u2,journal),'23514','Private journal ciphertext cannot change owner');

  INSERT INTO billing.plans(id,code,display_name_i18n) VALUES(plan,'DESIGN_TEST','{"vi":"Test only"}');
  INSERT INTO billing.plan_versions(id,plan_id,version,quotas) VALUES(pv,plan,1,'{"storageBytes":1000}');
  INSERT INTO billing.trial_policies(id,code,version,plan_version_id,duration_seconds)
    VALUES(trial_policy,'DESIGN_TEST',1,pv,604800);
  PERFORM pg_temp.require_true((SELECT duration_seconds=7*86400 FROM billing.trial_policies WHERE code='DEFAULT_TRIAL' AND active),'Configured initial trial policy is seven days');
  INSERT INTO billing.plans(code,display_name_i18n) VALUES('DESIGN_EXTRA','{"vi":"Another paid plan"}');
  PERFORM pg_temp.require_true((SELECT count(*)=1 FROM billing.plans WHERE code='DESIGN_EXTRA'),'Adding another plan needs catalog data rather than enum migration');
  INSERT INTO billing.products(id,product_id,store,environment,app_namespace,plan_version_id,period)
    VALUES(product,'design_test_yearly','APPLE','SANDBOX','design.test',pv,'P1Y');
  INSERT INTO billing.family_licenses(id,family_id) VALUES(lic1,f1),(lic2,f2);
  INSERT INTO billing.purchase_intents(id,family_id,license_id,purchaser_user_id,product_id,store,environment,app_namespace,client_idempotency_key,expires_at)
    VALUES(intent,f1,lic1,u1,product,'APPLE','SANDBOX','design.test',uuidv7(),now()+interval '1 hour'),
          (intent2,f2,lic2,outsider,product,'APPLE','SANDBOX','design.test',uuidv7(),now()+interval '1 hour');
  INSERT INTO billing.subscriptions(id,family_id,license_id,purchase_intent_id,purchaser_user_id,product_id,store,environment,app_namespace,original_transaction_id,store_binding_key,status)
    VALUES(sub,f1,lic1,intent,u1,product,'APPLE','SANDBOX','design.test','design-chain-A',decode(repeat('01',32),'hex'),'ACTIVE'),
          (sub2,f2,lic2,intent2,outsider,product,'APPLE','SANDBOX','design.test','design-chain-B',decode(repeat('02',32),'hex'),'ACTIVE');
  PERFORM pg_temp.reject(format('UPDATE billing.family_licenses SET family_id=%L WHERE id=%L',f2,lic1),'23514','License family owner is immutable');
  PERFORM pg_temp.reject(format('UPDATE billing.subscriptions SET family_id=%L WHERE id=%L',f2,sub),'23514','Restore cannot silently move subscription to another family');
  UPDATE billing.subscriptions SET purchaser_user_id=NULL,detached_purchaser_at=now() WHERE id=sub;
  PERFORM pg_temp.require_true((SELECT family_id=f1 AND license_id=lic1 FROM billing.subscriptions WHERE id=sub),'Detaching purchaser preserves original family license');
  PERFORM pg_temp.reject(format('UPDATE billing.subscriptions SET superseded_by=%L WHERE id=%L',sub2,sub),'23503','Store upgrade chain cannot cross family');
  INSERT INTO billing.subscription_transactions(id,subscription_id,family_id,license_id,store,environment,app_namespace,provider_transaction_id,kind,product_id,purchased_at,verified_at,payload_hash,plan_version_id)
    VALUES(tx,sub,f1,lic1,'APPLE','SANDBOX','design.test','design-transaction-1','PURCHASE',product,now(),now(),decode(repeat('03',32),'hex'),pv);
  PERFORM pg_temp.reject(format('INSERT INTO billing.subscription_transactions(subscription_id,family_id,license_id,store,environment,app_namespace,provider_transaction_id,kind,product_id,purchased_at,verified_at,payload_hash,plan_version_id) SELECT subscription_id,family_id,license_id,store,environment,app_namespace,provider_transaction_id,kind,product_id,purchased_at,verified_at,payload_hash,plan_version_id FROM billing.subscription_transactions WHERE id=%L',tx),'23505','Verified Store transaction cannot be granted twice');
  PERFORM pg_temp.reject(format('DELETE FROM billing.subscription_transactions WHERE id=%L',tx),'23514','Financial history cannot be physically deleted by normal CRUD');
  INSERT INTO billing.license_grants(id,family_id,license_id,plan_version_id,source,trial_policy_id,provenance_key,valid_from,valid_until)
    VALUES(trial,f1,lic1,pv,'TRIAL',trial_policy,'design-trial-A',now(),now()+interval '7 days');
  PERFORM pg_temp.reject(format('INSERT INTO billing.license_grants(family_id,license_id,plan_version_id,source,trial_policy_id,provenance_key,valid_from,valid_until) VALUES(%L,%L,%L,''TRIAL'',%L,''another-key'',now(),now()+interval ''7 days'')',f1,lic1,pv,trial_policy),'23505','Family trial cannot be reissued with a different provenance key');
  PERFORM pg_temp.reject(format('INSERT INTO billing.license_grants(family_id,license_id,plan_version_id,source,trial_policy_id,provenance_key,valid_from,valid_until) VALUES(%L,%L,%L,''TRIAL'',%L,''wrong-duration'',now(),now()+interval ''90 days'')',f2,lic2,pv,trial_policy),'23514','Trial duration must match the selected policy version');
  INSERT INTO billing.trial_policies(code,version,plan_version_id,duration_seconds) VALUES('DESIGN_TEST',2,pv,172800);
  PERFORM pg_temp.require_true((SELECT valid_until-valid_from=interval '7 days' FROM billing.license_grants WHERE id=trial),'New trial policy version does not rewrite already granted expiry');
  PERFORM pg_temp.reject(format('UPDATE billing.trial_policies SET duration_seconds=86400 WHERE id=%L',trial_policy),'23514','Published trial duration is immutable within a policy version');
  PERFORM pg_temp.reject(format('UPDATE billing.plan_versions SET quotas=''{}'' WHERE id=%L',pv),'23514','Issued plan version quotas are immutable');
  PERFORM pg_temp.reject(format('UPDATE billing.plan_versions SET entitlement_rank=999 WHERE id=%L',pv),'23514','Entitlement rank is versioned and immutable');
  INSERT INTO billing.subscription_transactions(id,subscription_id,family_id,license_id,store,environment,app_namespace,provider_transaction_id,kind,product_id,purchased_at,verified_at,payload_hash,plan_version_id)
    VALUES(renewal_tx,sub,f1,lic1,'APPLE','SANDBOX','design.test','design-renewal-after-payer-deleted','RENEWAL',product,now(),now(),decode(repeat('04',32),'hex'),pv);
  INSERT INTO billing.license_grants(family_id,license_id,plan_version_id,source,subscription_id,transaction_id,provenance_key,valid_from,valid_until)
    VALUES(f1,lic1,pv,'STORE',sub,renewal_tx,'design-paid-renewal',now(),now()+interval '1 year');
  PERFORM pg_temp.require_true((SELECT family_id=f1 FROM billing.license_grants WHERE transaction_id=renewal_tx),'Paid renewal can grant original family after purchaser is detached');

  INSERT INTO ops.job_runs(id,job_name,scope_key,family_id,scheduled_for,idempotency_key) VALUES(run,'design.check',f1::text,f1,now(),'design-run-1');
  PERFORM pg_temp.reject(format('DELETE FROM ops.job_runs WHERE id=%L',run),'23514','Pending job cannot be purged');
  PERFORM pg_temp.reject(format('UPDATE ops.job_runs SET status=''RUNNING'' WHERE id=%L',run),'23514','Running job requires lease ownership');
  PERFORM pg_temp.reject(format('INSERT INTO ops.job_runs(job_name,scope_key,family_id,scheduled_for,idempotency_key) SELECT job_name,scope_key,family_id,scheduled_for,''different-key'' FROM ops.job_runs WHERE id=%L',run),'23505','Duplicate scheduled occurrence has only one logical run');
  INSERT INTO ops.job_attempts(run_id,attempt_number,worker_id,fencing_token) VALUES(run,1,'design-worker',1);
  PERFORM pg_temp.reject(format('INSERT INTO ops.job_attempts(run_id,attempt_number,worker_id,fencing_token) VALUES(%L,1,''design-worker-2'',2)',run),'23505','Retry cannot overwrite or duplicate an attempt number');

  SELECT created_at,updated_at INTO audit_created,audit_updated FROM app.users WHERE id=u1;
  UPDATE app.users SET display_name='Updated by raw SQL',created_at='2000-01-01',updated_at='2000-01-01' WHERE id=u1;
  PERFORM pg_temp.require_true((SELECT created_at=audit_created AND updated_at>=audit_updated AND updated_at>'2000-01-01'::timestamptz FROM app.users WHERE id=u1),'Raw SQL update preserves created_at and refreshes updated_at');
END
$test$;

SELECT count(*) AS passed_domain_scenarios FROM design_check_results;
SELECT name AS passed_scenario FROM design_check_results ORDER BY name;
ROLLBACK;
