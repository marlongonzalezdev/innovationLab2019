import { FormGroup } from '@angular/forms';
import { SaveResult } from './../../shared/models/saveResult';
import { SkillVersion } from './../../shared/models/skillversion';
import { Skill } from './../../shared/models/skill';
import { Component, OnInit, Input, EventEmitter, Output, ViewChild } from '@angular/core';
import { MatOptionSelectionChange } from '@angular/material/core';
import { SkillCategory } from '../../shared/models/skill-category';
import { SkillServiceBase } from '../../shared/services/skill-service-base';
import { MatCheckboxChange, MatDialogRef, MatTableDataSource, MatSort, MatPaginator } from '@angular/material';
import { NotificationService } from '../../shared/services/notification.service';


@Component({
  selector: 'app-skilldetails',
  templateUrl: './skilldetails.component.html',
  styleUrls: ['./skilldetails.component.css']
})
export class SkilldetailsComponent implements OnInit {
  constructor(public skillservice: SkillServiceBase, private notificationService: NotificationService, 
              public dialogRef: MatDialogRef<SkilldetailsComponent>) { }

  @Input()
  skillCategories: any;
  selectedCategory: SkillCategory;
  isTechnology: boolean;
  isVersioned: boolean;
  versionList: SkillVersion[] = [];
  source: MatTableDataSource<SkillVersion>;
  displayedColumns = ['name', 'actions'];
  @ViewChild(MatSort, {static: false}) sort: MatSort;
  @ViewChild(MatPaginator, {static: false}) paginator: MatPaginator;
  // tslint:disable-next-line: no-output-on-prefix
  ngOnInit() {
    this.skillservice.getSkillCategory()
    .subscribe(response => {
      this.skillCategories = response;
    }
      );
    if (this.skillservice.form.controls.isVersioned.value) {
      this.isVersioned = true;
    } else { this.isVersioned = false; }
    this.versionList = this.skillservice.form.controls.versions.value;
    this.source = new MatTableDataSource<SkillVersion>(this.versionList);
    this.source.sort = this.sort;
    this.source.paginator = this.paginator;
  }

  onSubmit(skillData) {
    const defaultExpertiseValue = 0.0;
    const skill: Skill = {
      id: -1,
      relatedId: -1,
      category: skillData.category,
      code: skillData.name,
      name: skillData.name,
      defaultExpertise: defaultExpertiseValue,
      isVersioned: skillData.isVersioned,
      parentTechnologyId: -1,
      versions: this.versionList,
      weight: null

    };
    let result: SaveResult;
    this.skillservice.saveSkill(skill)
    .subscribe(response => {
      if (response.id) {
        result = {
          recordId: response.id,
          error: null
        };
        this.notificationService.sucess('Skill saved successfully');
      } else {
        result = {
          recordId: null,
          error: 'An error ocurred. Skill could not be saved'
        };
        this.notificationService.fail(result.error);
      }
    },
    (error: any) => {
      result = {
        recordId: null,
        error: 'An error ocurred. Skill could not be saved'
      };
    });
    this.notificationService.fail(result.error);
  }

  onClear() {
    this.skillservice.form.reset();
  }

  onSelect(change: MatOptionSelectionChange) {
     const categoryselected = change.source.viewValue;
     if (categoryselected === 'Technology') {
      this.isTechnology = true;
    } else {
      this.isTechnology = false;
      this.skillservice.form.controls.isVersioned.setValue(false);
      this.isVersioned = false;
    }
  }
  toggleSelection(change: MatCheckboxChange) {
    if (change.checked) {this.isVersioned = true; } else {
      this.isVersioned = false;
    }
  }

  addVersion(): void {
    const versionValue = this.skillservice.form.controls.version.value;
    if (!this.versionList.find(s => s.version === versionValue)) {
       const skillVersion: SkillVersion = {
        id: -1,
        relatedId: -1,
        defaultExpertise: 0.0,
        parentTechnologyId: -1,
        version: versionValue,
        startDate: new Date()
      };
       this.versionList.push(skillVersion);
  }
    this.source = new MatTableDataSource<SkillVersion>(this.versionList);
    this.source.sort = this.sort;
    this.source.paginator = this.paginator;
}
 deleteVersion(version): void {
  const index = this.versionList.indexOf(version, 0);
  if (index > -1) {
    this.versionList.splice(index, 1);
    this.source = new MatTableDataSource<SkillVersion>(this.versionList);
    this.source.sort = this.sort;
    this.source.paginator = this.paginator;
  }
}
onClose() {
  this.onClear();
  this.dialogRef.close();
}
}
