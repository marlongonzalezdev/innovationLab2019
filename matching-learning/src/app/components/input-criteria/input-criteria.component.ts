import {Component, Input, OnInit} from '@angular/core';
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
