import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { News } from './entities/news.entity';
import { CreateNewsDto } from './dto/create-news.dto';
import { UpdateNewsDto } from './dto/update-news.dto';

@Injectable()
export class NewsService {
  constructor(
    @InjectRepository(News)
    private readonly newsRepository: Repository<News>,
  ) { }

  private generateSlug(title: string): string {
    return title.toLowerCase().replace(/[^a-z0-9]+/g, '-') + '-' + Date.now();
  }

  async create(createNewsDto: CreateNewsDto, authorId: string): Promise<News> {
    const slug = this.generateSlug(createNewsDto.title);
    const news = this.newsRepository.create({
      ...createNewsDto,
      slug,
      authorId,
    });
    return this.newsRepository.save(news);
  }

  async findAll(isPublic: boolean): Promise<News[]> {
    const whereCondition = isPublic ? { isPublished: true } : {};
    return this.newsRepository.find({ where: whereCondition, relations: { author: true }, order: { createdAt: 'DESC' } });
  }

  async findBySlug(slug: string): Promise<News> {
    const news = await this.newsRepository.findOne({ where: { slug }, relations: { author: true } });
    if (!news) throw new NotFoundException('News not found');
    return news;
  }

  async findOne(id: string): Promise<News> {
    const news = await this.newsRepository.findOne({ where: { id } });
    if (!news) throw new NotFoundException('News not found');
    return news;
  }

  async update(id: string, updateNewsDto: UpdateNewsDto): Promise<News> {
    const news = await this.findOne(id);
    let slug = news.slug;
    if (updateNewsDto.title && updateNewsDto.title !== news.title) {
      slug = this.generateSlug(updateNewsDto.title);
    }

    Object.assign(news, { ...updateNewsDto, slug });
    return this.newsRepository.save(news);
  }

  async remove(id: string): Promise<void> {
    const news = await this.findOne(id);
    await this.newsRepository.remove(news);
  }
}
