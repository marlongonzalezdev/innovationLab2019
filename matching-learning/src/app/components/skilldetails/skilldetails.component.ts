import { FormGroup } from '@angular/forms';
import { SaveResult } from './../../shared/models/saveResult';
import { SkillVersion } from './../../shared/models/skillversion';
import { Skill } from './../../shared/models/skill';
import { Component, OnInit, Input, EventEmitter, Output } from '@angular/core';
import { MatOptionSelectionChange } from '@angular/material/core';
import { SkillCategory } from '../../shared/models/skill-category';
import { SkillServiceBase } from '../../shared/services/skill-service-base';
import { MatCheckboxChange } from '@angular/material';


@Component({
  selector: 'app-skilldetails',
  templateUrl: './skilldetails.component.html',
  styleUrls: ['./skilldetails.component.css']
})
export class SkilldetailsComponent implements OnInit {
  constructor(public skillservice: SkillServiceBase) { }

  @Input()
  set skill(skill: Skill) {}
  get skill(): Skill { return this.skillOrigin; }
  skillCategories: any;
  selectedCategory: SkillCategory;
  isTechnology: boolean;
  isVersioned: boolean;
  versionList: SkillVersion[] = [];
  private skillOrigin: Skill;
  @Output()
  public updateShowContent = new EventEmitter<boolean>();
  // tslint:disable-next-line: no-output-on-prefix
  @Output()
  public onSaveComplete = new EventEmitter<SaveResult>();

  ngOnInit() {
    this.skillservice.getSkillCategory()
    .subscribe(response => {
      this.skillCategories = response;
    }
      );
  }

  onSubmit(skillData) {
    const defaultExpertiseValue = 0.0;
    const skill: Skill = {
      id: -1,
      relatedId: -1,
      category: skillData.category.id,
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
       result = {
        recordId: response.id,
        error: null
      };
       this.onSaveComplete.emit(result);
    },
    (error: any) => {
      result = {
        recordId: null,
        error
      };
    });
    this.onSaveComplete.emit(result);
  }

  onClear() {
    this.skillservice.form.reset();
    const displayContent = false;
    this.updateShowContent.emit(displayContent);
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
}
 deleteVersion(version: SkillVersion): void {
  const index = this.versionList.indexOf(version, 0);
  if (index > -1) {
    this.versionList.splice(index, 1);
  }
}
}
