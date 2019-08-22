import { SkillService } from './../skills/services/skill.service';
import { SkillCategory } from './../../models/skill-category';
import { Skills } from './../../models/skills';
import { Component, OnInit, Input, EventEmitter, Output } from '@angular/core';
import { SkillServiceBase } from '../skills/services/skill-servie-base';
import { MatOptionSelectionChange } from '@angular/material/core';

@Component({
  selector: 'app-skilldetails',
  templateUrl: './skilldetails.component.html',
  styleUrls: ['./skilldetails.component.css']
})
export class SkilldetailsComponent implements OnInit {
  constructor(public skillservice: SkillServiceBase) { }

  @Input()
  set skill(skill: Skills) {}
  get skill(): Skills { return this.skillOrigin; }
  skillCategories: any;
  selectedCategory: SkillCategory;
  isTechnology: boolean;
  private skillOrigin: Skills;
  @Output()
    public updateShowContent = new EventEmitter<boolean>();

  ngOnInit() {
    this.skillservice.getSkillCategory()
    .subscribe(response => {
      this.skillCategories = response;
    }
      );
  }

  onSubmit() {
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
    }
  }
}
