import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Request, UseInterceptors, UploadedFile, BadRequestException } from '@nestjs/common';
import { NewsService } from './news.service';
import { CreateNewsDto } from './dto/create-news.dto';
import { UpdateNewsDto } from './dto/update-news.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname } from 'path';

@Controller('news')
export class NewsController {
  constructor(private readonly newsService: NewsService) {}

  @Get()
  findAll() {
    return this.newsService.findAll(true);
  }

  @Get(':slug')
  findBySlug(@Param('slug') slug: string) {
    return this.newsService.findBySlug(slug);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('Admin Konten', 'Super Admin')
  @Post()
  create(@Body() createNewsDto: CreateNewsDto, @Request() req) {
    return this.newsService.create(createNewsDto, req.user.id);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('Admin Konten', 'Super Admin')
  @Patch(':id')
  update(@Param('id') id: string, @Body() updateNewsDto: UpdateNewsDto) {
    return this.newsService.update(id, updateNewsDto);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('Admin Konten', 'Super Admin')
  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.newsService.remove(id);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('Admin Konten', 'Super Admin')
  @Post('upload')
  @UseInterceptors(
    FileInterceptor('file', {
      limits: {
        fileSize: 2 * 1024 * 1024, // 2MB
      },
      fileFilter: (req, file, callback) => {
        const allowedMimeTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
        if (!allowedMimeTypes.includes(file.mimetype)) {
          return callback(new BadRequestException('Only JPG, JPEG, PNG, and WEBP files are allowed!'), false);
        }
        callback(null, true);
      },
      storage: diskStorage({
        destination: './uploads/news',
        filename: (req, file, callback) => {
          const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
          const ext = extname(file.originalname);
          callback(null, `${file.fieldname}-${uniqueSuffix}${ext}`);
        },
      }),
    }),
  )
  uploadFile(@UploadedFile() file: Express.Multer.File) {
    if (!file) {
      throw new BadRequestException('File is required');
    }
    return {
      message: 'File uploaded successfully',
      filePath: `/uploads/news/${file.filename}`,
    };
  }
}
