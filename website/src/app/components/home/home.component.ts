// import { NgClass } from '@angular/common';
import { NgIf, NgStyle } from '@angular/common';
import { Component } from '@angular/core';

// declare const angular: any;

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [NgIf,
            NgStyle,
            ],
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss'
})
export class HomeComponent {
}
