import { Component } from '@angular/core';
import { HomeComponent } from '../home/home.component';
import { AboutComponent } from '../about/about.component';
import { SkillsComponent } from '../skills/skills.component';

@Component({
  selector: 'app-main',
  standalone: true,
  imports: [HomeComponent,
            AboutComponent,
            SkillsComponent,],
  templateUrl: './main.component.html',
  styleUrl: './main.component.css'
})
export class MainComponent {
  constructor(){}

  ngOnInit(): void{

  }
}
