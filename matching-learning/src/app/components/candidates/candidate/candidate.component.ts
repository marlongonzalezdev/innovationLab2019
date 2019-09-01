import {Component, OnInit} from '@angular/core';

import {Observable} from 'rxjs';
import {RelationType} from 'src/app/shared/models/relationType';
import {Candidate} from 'src/app/shared/models/candidate';
import {DeliveryUnit} from 'src/app/shared/models/deliveryUnit';
import {CandidateService} from 'src/app/shared/services/candidate.service';
import {DeliveryUnitService} from 'src/app/shared/services/delivery-unit.service';
import {RelationTypeService} from 'src/app/shared/services/relation-type.service';
import {NotificationService} from 'src/app/shared/services/notification.service';
import {MatDialogRef, MatTableDataSource} from '@angular/material';
import {Role} from '../../../shared/models/role';
import {Evaluation} from '../../../shared/models/evaluation';

@Component({
  selector: 'app-candidate',
  templateUrl: './candidate.component.html',
  styleUrls: ['./candidate.component.css']
})
export class CandidateComponent implements OnInit {

  deliveryUnits: Observable<DeliveryUnit[]>;
  relationTypes: Observable<RelationType[]>;
  roles: Observable<Role[]>;
  public candidate: Candidate;

  constructor(private candidateService: CandidateService, private deliveryUnitService: DeliveryUnitService,
              private relationTypeService: RelationTypeService, private notificationService: NotificationService,
              public dialogRef: MatDialogRef<CandidateComponent>) {
  }

  ngOnInit() {
    this.deliveryUnits = this.deliveryUnitService.getDeliveryUnits();
    this.relationTypes = this.relationTypeService.getRelationTypes();
    this.roles = this.candidateService.getCandidateRoles();
  }

  onClear() {
    this.candidateService.form.reset();
    this.candidateService.InitializeFormGroup();
  }

  onSubmit() {
    if (this.candidateService.form.valid) {

      // const currentRole: Role = {
      //   id: this.candidateService.form.controls.roleId.value,
      //   code: '',
      //   name: ''
      // };

      this.candidateService.getCandidateById(this.candidateService.form.controls.$key.value)
        .subscribe(response => {
          this.candidate = response;
          this.candidate.deliveryUnitId = this.candidateService.form.controls.du.value;
          this.candidate.relationType = this.candidateService.form.controls.relationType.value;
          this.candidate.firstName = this.candidateService.form.controls.firstName.value;
          this.candidate.lastName = this.candidateService.form.controls.lastName.value;
          this.candidate.candidateRoleId = this.candidateService.form.controls.roleId.value;
          this.candidate.inBench = this.candidateService.form.controls.isInBench.value;
          this.candidate.isActive = this.candidateService.form.controls.isActive.value;
          this.candidateService.addCandidate(this.candidate).subscribe(
            elem => {
              this.notificationService.sucess('Candidate saved successfully.');
              this.onClear();
              console.log(elem);
              this.onClose();
            }
          );
        });
    }
  }

  onClose() {
    this.onClear();
    this.dialogRef.close();
  }
}
