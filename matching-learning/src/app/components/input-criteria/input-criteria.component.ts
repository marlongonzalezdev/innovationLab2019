import {Component, Input, OnInit} from '@angular/core';
import {coerceNumberProperty} from '@angular/cdk/coercion';
import {Skills} from '../../mock-skills';
import {Skill} from '../../skill';
import {Project} from '../../project';

@Component({
    selector: 'app-input-criteria',
    templateUrl: './input-criteria.component.html',
    styleUrls: ['./input-criteria.component.css']
})
export class InputCriteriaComponent implements OnInit {
    project: Project;
    display: boolean;
    skillList = Skills;

    selectedSkill: Skill;
    expectedScore: number;
    showContent: boolean;

  autoTicks = false;
  disabled = false;
  invert = false;
  max = 100;
  min = 0;
  showTicks = false;
  step = 1;
  thumbLabel = false;
  value = 0;
  vertical = false;

  get tickInterval(): number | 'auto' {
    return this.showTicks ? (this.autoTicks ? 'auto' : this._tickInterval) : 0;
  }
  set tickInterval(value) {
    this._tickInterval = coerceNumberProperty(value);
  }
  private _tickInterval = 1;

    constructor() {
        this.project = new Project();
        this.project.name = 'Example';
        this.project.skills = [];
        this.display = false;
        this.showContent = false;
    }

    ngOnInit() {
    }

    add(skill: Skill): void {

        if (!skill || !this.expectedScore || this.expectedScore > 100) {
            return;
        }
        if (!this.project.skills.find(s => s === skill)) {
            skill.weight = this.expectedScore / 100;
            this.project.skills.push(skill);
            this.selectedSkill = undefined;
            this.expectedScore = undefined;
        }
        this.display = true;
    }

    delete(skill: Skill): void {
      const index = this.project.skills.indexOf(skill, 0);
      if (index > -1) {
        this.project.skills.splice(index, 1);
        if (this.project.skills.length === 0) {
          this.display = false;
          this.showContent = false;
        }
      }
    }
}
