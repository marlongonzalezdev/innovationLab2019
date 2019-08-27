import { Component, OnInit } from '@angular/core';

import { Observable } from 'rxjs';
import { RelationType } from 'src/app/shared/models/relationType';
import { Candidate } from 'src/app/shared/models/candidate';
import { DeliveryUnit } from 'src/app/shared/models/deliveryUnit';
import { CandidateService } from 'src/app/shared/services/candidate.service';
import { DeliveryUnitService } from 'src/app/shared/services/delivery-unit.service';
import { RelationTypeService } from 'src/app/shared/services/relation-type.service';
import { NotificationService } from 'src/app/shared/services/notification.service';
import {MatDialogRef} from '@angular/material';

@Component({
  selector: 'app-candidate',
  templateUrl: './candidate.component.html',
  styleUrls: ['./candidate.component.css']
})
export class CandidateComponent implements OnInit {

  deliveryUnits: Observable<DeliveryUnit[]>;
  relationTypes: Observable<RelationType[]>;

  constructor(private service: CandidateService, private deliveryUnitService: DeliveryUnitService,
              private relationTypeService: RelationTypeService, private notificationService: NotificationService,
              public dialogRef: MatDialogRef<CandidateComponent>) { }

  ngOnInit() {
    this.deliveryUnits = this.deliveryUnitService.getDeliveryUnits();
    this.relationTypes = this.relationTypeService.getRelationTypes();
  }

  onClear() {
    this.service.form.reset();
    this.service.InitializeFormGroup();
  }

  onSubmit() {
    if (this.service.form.valid) {
      const candidate: Candidate = {
        id: -1,
        deliveryUnitId: 13,
        deliveryUnit: null,
        relationType: 1,
        firstName: 'Juan',
        lastName: 'Perez',
        name: '',
        activeRole: null,
        rolesHistory: null,
        docType: null,
        docNumber: null,
        employeeNumber: 43245,
        inBench: true,
        picture: null,
        isActive: true,
		evaluations: null
      };

      this.service.addCandidate(candidate).subscribe(
        elem => {
          this.notificationService.sucess('Candidate added successfully.');
          this.onClear();
          console.log(elem);
          this.onClose();
        }
      );
    }
  }

  onClose() {
    this.onClear();
    this.dialogRef.close();
  }
}
